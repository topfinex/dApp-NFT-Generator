<?php
namespace App\Observers;
use App\Models\Nft;

class LogNftCreation
{
    public function created(Nft $nft)
    {
        Log::info('NFT Created via Observer', [
            'nft_id' => $nft->id,
            'user_id' => auth()->id(),
            'timestamp' => now()->toDateTimeString(),
        ]);
    }

    public function updated(Nft $nft)
    {
        Log::info('NFT Updated via Observer', [
            'nft_id' => $nft->id,
            'user_id' => auth()->id(),
            'timestamp' => now()->toDateTimeString(),
        ]);
    }

    public function deleted(Nft $nft)
    {
        Log::info('NFT Deleted via Observer', [
            'nft_id' => $nft->id,
            'user_id' => auth()->id(),
            'timestamp' => now()->toDateTimeString(),
        ]);
    }
}