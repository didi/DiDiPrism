

declare var window: Window;
interface Window {
  PRISM_PLAYBACK_PLAY: any;
}

import PlayBack from './play';

const play = new PlayBack();

if (typeof window === 'object') {
	window.PRISM_PLAYBACK_PLAY = play.play.bind(play);
}
