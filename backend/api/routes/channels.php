<?php

use Illuminate\Support\Facades\Broadcast;

Broadcast::channel('auctions.{auctionId}', function ($user, $auctionId) {
    return true; // Public channel, anyone can listen
});

Broadcast::channel('auctions', function ($user) {
    return true; // Public channel for list updates
});
