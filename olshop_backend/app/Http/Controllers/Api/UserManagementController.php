<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Models\User;


class UserManagementController extends Controller
{
    public function index()
    {
        $users = User::all();
        return response()->json($users);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'firstName' => ['required', 'string', 'max:25'],
            'lastName' => ['required', 'string', 'max:25'],
            'email' => ['required', 'email', 'unique:users,email'],
            'password' => ['required', 'string', 'min:8'],
            'userType' => ['required', 'string', 'in:admin,guest'],
        ]);

        $user = User::create([
            'firstName' => $data['firstName'],
            'lastName' => $data['lastName'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'userType' => $data['userType'],
            'status' => 'active',
        ]);

        return response()->json($user, 201);
    }

    public function update(Request $request, $id)
    {
        $user = User::find($id);
        $user->update($request->only(['id', 'firstName', 'lastName', 'email', 'userType']));
        return response()->json($user);
    }

    public function destroy($id)
    {
        $user = User::find($id);
        $user->delete();
        return response()->json(['message' => 'User deleted successfully']);
    }

    public function deactivateGuest($id)
    {
        $user = User::find($id);
        if ($user->userType == 'guest') {
            $user->update(['status' => 'inactive']);
            return response()->json(['message' => 'Guest deactivated successfully']);
        }
        return response()->json(['message' => 'User is not a guest']);
    }

    public function reactivateGuest($id)
    {
        $user = User::find($id);
        if ($user->userType == 'guest') {
            $user->update(['status' => 'active']);
            return response()->json(['message' => 'Guest reactivated successfully']);
        }
        return response()->json(['message' => 'User is not a guest']);
    }
}
