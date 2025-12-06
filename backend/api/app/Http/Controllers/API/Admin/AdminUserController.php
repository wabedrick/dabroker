<?php

namespace App\Http\Controllers\API\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Admin\UpdateUserRequest;
use App\Http\Resources\UserResource;
use App\Models\ModerationLog;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Arr;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class AdminUserController extends Controller
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $users = User::query()
            ->with(['roles', 'permissions'])
            ->when($request->search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%")
                    ->orWhere('email', 'like', "%{$search}%");
            })
            ->when($request->role, function ($query, $role) {
                $query->role($role);
            })
            ->latest()
            ->paginate(20);

        return UserResource::collection($users);
    }

    public function show(User $user): UserResource
    {
        return new UserResource($user->load(['roles', 'permissions', 'properties']));
    }

    public function update(UpdateUserRequest $request, User $user): UserResource
    {
        $data = $request->validated();
        $originalStatus = $user->status;
        $originalRoles = $user->getRoleNames()->values()->all();

        if (array_key_exists('roles', $data)) {
            $restrictedRoles = ['admin', 'super_admin'];
            $targetHasRestrictedRole = !empty(array_intersect($originalRoles, $restrictedRoles));
            $newHasRestrictedRole = !empty(array_intersect($data['roles'], $restrictedRoles));

            /** @var \App\Models\User $currentUser */
            $currentUser = Auth::user();

            if (($targetHasRestrictedRole || $newHasRestrictedRole) && !$currentUser->can('admin.manage_admins')) {
                abort(403, 'You do not have permission to manage admin roles.');
            }
        }

        DB::transaction(function () use ($user, $data): void {
            $allowed = array_filter(
                [
                    'name',
                    'email',
                    'phone',
                    'country_code',
                    'bio',
                    'status',
                    'preferred_role',
                    'metadata',
                ],
                fn(string $key): bool => array_key_exists($key, $data)
            );

            if (! empty($allowed)) {
                $user->fill(Arr::only($data, $allowed));
                $user->save();
            }

            if (array_key_exists('roles', $data)) {
                $user->syncRoles($data['roles']);
            }
        });

        if (array_key_exists('status', $data) && $data['status'] !== $originalStatus) {
            $this->logUserModeration(
                $user,
                'user_status_updated',
                null,
                ['status' => $originalStatus],
                ['status' => $data['status']],
            );
        }

        if (array_key_exists('roles', $data)) {
            $newRoles = $user->getRoleNames()->values()->all();
            if ($newRoles !== $originalRoles) {
                $this->logUserModeration(
                    $user,
                    'user_roles_updated',
                    null,
                    ['roles' => $originalRoles],
                    ['roles' => $newRoles],
                );
            }
        }

        return new UserResource($user->fresh(['roles', 'permissions', 'properties']));
    }

    public function ban(User $user): UserResource
    {
        $previousStatus = $user->status;

        $user->update(['status' => 'banned']);
        $user->tokens()->delete(); // Revoke all tokens

        $this->logUserModeration(
            $user,
            'user_banned',
            null,
            ['status' => $previousStatus],
            ['status' => 'banned'],
        );

        return new UserResource($user->load(['roles', 'permissions']));
    }

    public function activate(User $user): UserResource
    {
        $previousStatus = $user->status;

        $user->update(['status' => 'active']);

        $this->logUserModeration(
            $user,
            'user_activated',
            null,
            ['status' => $previousStatus],
            ['status' => 'active'],
        );

        return new UserResource($user->load(['roles', 'permissions']));
    }

    public function destroy(User $user): \Illuminate\Http\JsonResponse
    {
        $targetRoles = $user->getRoleNames()->values()->all();
        $restrictedRoles = ['admin', 'super_admin'];
        $isTargetAdmin = !empty(array_intersect($targetRoles, $restrictedRoles));

        /** @var \App\Models\User $currentUser */
        $currentUser = Auth::user();

        if ($isTargetAdmin && !$currentUser->can('admin.manage_admins')) {
            abort(403, 'You do not have permission to delete admin users.');
        }

        $user->delete();

        return response()->json(['message' => 'User deleted successfully.']);
    }

    private function logUserModeration(
        User $user,
        string $action,
        ?string $reason,
        array $oldValues,
        array $newValues
    ): void {
        ModerationLog::create([
            'moderatable_type' => User::class,
            'moderatable_id' => $user->id,
            'moderatable_public_id' => (string) $user->id,
            'performed_by' => Auth::id(),
            'action' => $action,
            'previous_status' => $oldValues['status'] ?? null,
            'new_status' => $newValues['status'] ?? null,
            'reason' => $reason,
            'old_values' => $oldValues,
            'new_values' => $newValues,
        ]);
    }
}
