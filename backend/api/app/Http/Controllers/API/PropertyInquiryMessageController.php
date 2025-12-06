<?php

namespace App\Http\Controllers\API;

use App\Events\PropertyInquiryMessageCreated;
use App\Http\Controllers\Controller;
use App\Http\Requests\Property\SendInquiryMessageRequest;
use App\Http\Resources\PropertyInquiryMessageResource;
use App\Models\PropertyInquiry;
use App\Notifications\PropertyInquiryReplyNotification;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class PropertyInquiryMessageController extends Controller
{
    public function store(SendInquiryMessageRequest $request, PropertyInquiry $inquiry): JsonResponse
    {
        $user = $request->user();

        abort_if($user->id !== $inquiry->owner_id && $user->id !== $inquiry->sender_id, 403, 'You do not have access to this inquiry.');

        $data = $request->validated();

        $message = $inquiry->messages()->create([
            'sender_id' => $user->id,
            'message' => $data['message'],
            'metadata' => $data['metadata'] ?? null,
        ]);

        if ($user->id === $inquiry->owner_id) {
            $inquiry->forceFill([
                'status' => PropertyInquiry::STATUS_RESPONDED,
                'responded_at' => now(),
                'read_at' => now(),
                'buyer_read_at' => null,
            ])->save();
        } else {
            $inquiry->forceFill([
                'status' => PropertyInquiry::STATUS_OPEN,
                'read_at' => null,
                'buyer_read_at' => now(),
            ])->save();
        }

        $recipient = $user->id === $inquiry->owner_id ? $inquiry->sender : $inquiry->owner;

        if ($recipient) {
            $recipient->notify(new PropertyInquiryReplyNotification(
                $inquiry->loadMissing('property'),
                $message->load('sender:id,name,preferred_role')
            ));
        }

        PropertyInquiryMessageCreated::dispatch($inquiry, $message);

        Log::info('property_inquiry.message_sent', [
            'inquiry_id' => $inquiry->public_id,
            'message_id' => $message->public_id,
            'sender_id' => $user->id,
        ]);

        return response()->json([
            'message' => 'Reply sent.',
            'data' => new PropertyInquiryMessageResource($message),
        ], 201);
    }

    public function markRead(Request $request, PropertyInquiry $inquiry): JsonResponse
    {
        $user = $request->user();

        abort_if($user->id !== $inquiry->owner_id && $user->id !== $inquiry->sender_id, 403, 'You do not have access to this inquiry.');

        $updates = [];

        if ($user->id === $inquiry->owner_id && is_null($inquiry->read_at)) {
            $updates['read_at'] = now();
        }

        if ($user->id === $inquiry->sender_id && is_null($inquiry->buyer_read_at)) {
            $updates['buyer_read_at'] = now();
        }

        if ($updates !== []) {
            $inquiry->forceFill($updates)->save();
        }

        return response()->json([
            'message' => 'Conversation marked as read.',
        ]);
    }
}
