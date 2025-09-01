<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\FailedLoginAttempt;
use Illuminate\Support\Facades\RateLimiter;
use Carbon\Carbon;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $data = $request->validate([
            'firstName' => ['required', 'string', 'max:25'],
            'lastName' => ['required', 'string', 'max:25'],
            'email' => ['required', 'email', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
            'passwordConfirmation' => ['required', 'string', 'min:8', 'same:password'],
        ]);

        $user = User::create([
            'firstName' => $data['firstName'],
            'lastName' => $data['lastName'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'userType' => 'guest',
            'status' => 'active',
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token,
        ], 201);
    }

    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        $email = $credentials['email'];

        if ($this->isEmailLocked($email)) {
            return response()->json([
                'message' => 'This email is temporarily locked due to too many failed attempts. Please try again in 5 minutes.'
            ], 423);
        }

        if (!Auth::attempt(['email' => $email, 'password' => $credentials['password']])) {
            $this->recordFailedAttempt($email, $request->ip());

            if ($this->shouldLockEmail($email)) {
                return response()->json([
                    'message' => 'Too many failed attempts. This email is now locked for 5 minutes.'
                ], 423);
            }

            return response()->json([
                'message' => 'Invalid credentials'
            ], 422);
        }

        $this->clearFailedAttempts($email);

        $user = $request->user();
        if ($user->status !== 'active') {
            Auth::logout();
            return response()->json([
                'message' => 'Account is deactivated. Please contact an administrator.'
            ], 423);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token
        ]);
    }

    private function isEmailLocked($email)
    {
        $failedAttempts = FailedLoginAttempt::where('email', $email)
            ->where('attempted_at', '>=', Carbon::now()->subMinutes(5))
            ->count();

        return $failedAttempts >= 5;
    }

    private function shouldLockEmail($email)
    {
        $failedAttempts = FailedLoginAttempt::where('email', $email)
            ->where('attempted_at', '>=', Carbon::now()->subMinutes(5))
            ->count();

        return $failedAttempts >= 5;
    }

    private function recordFailedAttempt($email, $ipAddress)
    {
        FailedLoginAttempt::create([
            'email' => $email,
            'ip_address' => $ipAddress,
            'attempted_at' => Carbon::now()
        ]);
    }

    private function clearFailedAttempts($email)
    {
        FailedLoginAttempt::where('email', $email)->delete();
    }

    public function me(Request $request)
    {
        $user = $request->user();

        if ($user->status !== 'active') {
            return response()->json([
                'message' => 'Account is deactivated. Please contact an administrator.'
            ], 423);
        }

        return response()->json([
            'user' => $user,
        ]);
    }

    public function logout(Request $request)
    {
        $request->user()?->currentAccessToken()?->delete();
        return response()->json([
            'message' => 'Logged out successfully'
        ], 200);
    }
}
