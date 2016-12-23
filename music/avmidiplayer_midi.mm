/*
 * Apple macOS AVMIDIPlayer routine added by Genki Ishida and Kenta Kubo
 *
 * This file is part of the Simutrans project under the artistic licence.
 *
 */

#import "music.h"

#import <Foundation/NSArray.h>
#import <Foundation/NSString.h>
#import <AVFoundation/AVMIDIPlayer.h>


static float defaultVolume = 0.5; // a nice default volume
static int   nowPlaying    = -1;  // the number of the track currently being played

static NSMutableArray* movies;


void dr_set_midi_volume(int const vol)
{
}


int dr_load_midi(char const* const filename)
{
	NSString* const s = [NSString stringWithUTF8String: filename];
	AVMIDIPlayer* const m = [[AVMIDIPlayer alloc] initWithContentsOfURL: [NSURL fileURLWithPath: s] soundBankURL: [[NSBundle mainBundle] URLForResource: @"Florestan_Basic_GM_GS" withExtension: @"sf2"] error: nil];
	if (m) {
		[movies addObject: m];
	}
	return movies.count - 1;
}


void dr_play_midi(int const key)
{
	// Play the file referenced by the supplied key.
	AVMIDIPlayer* const m = [movies objectAtIndex: key];
	[m play: nil];
	nowPlaying = key;
}


void dr_stop_midi()
{
	// We assume the 'nowPlaying' key holds the most recently started track.
	AVMIDIPlayer* const m = [movies objectAtIndex: nowPlaying];
	[m stop];
}


sint32 dr_midi_pos()
{
	if (nowPlaying == -1) {
		return -1;
	}
	float const rate = [[movies objectAtIndex: nowPlaying] rate];
	return rate > 0 ? 0 : -1;
}


void dr_destroy_midi()
{
	if (nowPlaying != -1) {
		dr_stop_midi();
	}
}


bool dr_init_midi()
{
	movies = [NSMutableArray arrayWithCapacity: MAX_MIDI];
	return true;
}
