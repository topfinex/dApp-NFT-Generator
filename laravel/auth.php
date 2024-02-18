<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'username' => 'required|unique:users',
            'password' => 'required|min:6',
        ]);

        $user = new User();
        $user->username = $request->username;
        $user->password = Hash::make($request->password);
        $user->wallet_address = generate_wallet_address(); // Assuming you have a function to generate wallet address
        $user->save();

        return response()->json(['message' => 'User registered successfully', 'wallet_address' => $user->wallet_address], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required',
        ]);

        $user = User::where('username', $request->username)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Invalid username or password'], 401);
        }

        return response()->json(['message' => 'Login successful', 'wallet_address' => $user->wallet_address], 200);
    }
}
