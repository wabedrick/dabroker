<?php

namespace App\Http\Controllers\API\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\LodgingResource;
use App\Models\Lodging;
use App\Models\ModerationLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class LodgingApprovalController extends Controller
{
    public function approve(Lodging $lodging)
    {
        $previousStatus = $lodging->status;

        $lodging->forceFill([
            'status' => 'approved',
            'approved_at' => now(),
            'approved_by' => Auth::id(),
            'rejection_reason' => null,
            'published_at' => $lodging->published_at ?? now(),
        ])->save();

        $this->logModeration(
            $lodging,
            'lodging_approved',
            null,
            ['status' => $previousStatus],
            ['status' => 'approved'],
        );

        return new LodgingResource($lodging->fresh(['host', 'approver']));
    }

    public function reject(Request $request, Lodging $lodging)
    {
        $validated = $request->validate([
            'reason' => 'required|string',
        ]);

        $previousStatus = $lodging->status;

        $lodging->forceFill([
            'status' => 'rejected',
            'approved_at' => null,
            'approved_by' => Auth::id(),
            'rejection_reason' => $validated['reason'],
        ])->save();

        $this->logModeration(
            $lodging,
            'lodging_rejected',
            $validated['reason'],
            ['status' => $previousStatus],
            ['status' => 'rejected'],
        );

        return new LodgingResource($lodging->fresh(['host', 'approver']));
    }

    private function logModeration(
        Lodging $lodging,
        string $action,
        ?string $reason,
        array $oldValues,
        array $newValues
    ): void {
        ModerationLog::create([
            'moderatable_type' => Lodging::class,
            'moderatable_id' => $lodging->id,
            'moderatable_public_id' => $lodging->public_id,
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
