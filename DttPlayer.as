package {
	import flash.display.StageScaleMode;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;


	public class DttPlayer extends Sprite {

		private var _sound: Sound;
		private var _channel: SoundChannel = new SoundChannel(); //для организации паузы	
		private var _buffer: SoundLoaderContext = new SoundLoaderContext(5000); //предзагрузка 5 сек
		private var _nextMal: Boolean = false; // закончилось воспроизведение, играть снова

		public function DttPlayer(): void {
			with(stage) {
				scaleMode = StageScaleMode.NO_SCALE;
				showDefaultContextMenu = false;
				frameRate = 30;
			}
			tabEnabled = false;
			this.addEventListener(Event.ENTER_FRAME, init);
		}


		// init Player
		private function init(e: Event): void {
			if (loaderInfo.bytesLoaded < loaderInfo.bytesTotal) return;
			this.removeEventListener(Event.ENTER_FRAME, init);
			nulledUi();

			_sound = new Sound();
			ExternalInterface.addCallback("playSound", play_sound);

			this.close_btn.addEventListener(MouseEvent.CLICK, closePlayerWin);
		}


		public function play_sound(songURL: String): void {
			if (songURL == "") {
				stop_sound();
				nulledUi();
				return;
			}

			var request: URLRequest = new URLRequest(songURL);

			try {
				_sound.load(request, _buffer);
				_channel = _sound.play(0);
			} catch (errObject: Error) {
				return;
			}
			_sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			//_sound.addEventListener(ProgressEvent.PROGRESS, ioProgressHandler);	
			//_sound.addEventListener(Event.COMPLETE, ioLoadedHandler);
			_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			addEventListener(Event.ENTER_FRAME, playingHandler);

			this.play_btn.addEventListener(MouseEvent.CLICK, controlsClick);
			this.pause_btn.addEventListener(MouseEvent.CLICK, controlsClick);
			this.play_btn.visible = false;
			this.pause_btn.visible = true;
			_nextMal = false;
		}


		public function stop_sound(): void {
			SoundMixer.stopAll();
			try {
				_sound.close();
			} catch (ignore: Error) {}
			_sound = new Sound(); //обнуление объекта
			removeEventListener(Event.ENTER_FRAME, playingHandler);
		}


		// обнуление интерфейса плеера
		private function nulledUi(): void {
			this.scroller_load_mc.scaleX = this.scroller_play_mc.scaleX = 0;
			this.time_txt.text = "00:00";
			this.play_btn.visible = true;
			this.pause_btn.visible = true;
			this.play_btn.removeEventListener(MouseEvent.CLICK, controlsClick);
			this.pause_btn.removeEventListener(MouseEvent.CLICK, controlsClick);
		}

		private function playingHandler(event: Event): void {
			if (_sound.bytesLoaded > 0) {
				var loadPercent: Number = _sound.bytesLoaded / _sound.bytesTotal;
				var playbackPercent: Number = _channel.position / (_sound.length / loadPercent);

				/*ExternalInterface.call("showPlayerStatus", "Sound file's size is " + _sound.bytesTotal + " bytes.\n" 
									   + "Bytes being loaded: " + _sound.bytesLoaded + "\n" 
									   + "Percentage of sound file that is loaded " + loadPercent + ".\n"
									   + "Sound playback is " + playbackPercent + " complete.\n\n" + _channel.position + ' / ' + _sound.length);*/
				if (loadPercent >= 0 && loadPercent <= 1)
					this.scroller_load_mc.scaleX = loadPercent;
				if (playbackPercent >= 0 && playbackPercent <= 1)
					this.scroller_play_mc.scaleX = playbackPercent;
				show_leng_time(_sound.bytesTotal / (_sound.bytesLoaded / _sound.length)); //расчитываем общую длину файла
			}
		}


		/******************
		 * листнеры кнопок */
		private function controlsClick(mE: MouseEvent): void {
			if (mE.target == this.play_btn) {
				this.pause_btn.visible = true;
				this.play_btn.visible = false;

				if (!_nextMal) {
					_channel = _sound.play(_channel.position);
					_channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				} else {
					var Url: String = _sound.url;
					stop_sound();
					play_sound(Url);
					//ExternalInterface.call("showPlayerStatus", Url);
				}
			} else {
				this.pause_btn.visible = false;
				this.play_btn.visible = true;
				_channel.stop();
			}
		}
		private function closePlayerWin(mE: MouseEvent): void {
			nulledUi();
			stop_sound();
			ExternalInterface.call("closePlayerWin");
		}
		/**
		 * end листнеры кнопок
		 ******************/





		/********************
		 * _sound события */
		private function ioErrorHandler(evt: IOErrorEvent): void {
			ExternalInterface.call("showPlayerStatus", "Не могу загрузить звуковой файл.");
			stop_sound();
			nulledUi();
		}
		private function show_leng_time(miliSecs: Number): void {
			var secs: String = ((miliSecs / 1000) % 60 >= 10) ? String(Math.round((miliSecs / 1000) % 60)) : "0" + String(Math.round((miliSecs / 1000) % 60));
			var mins: String = ((miliSecs / 1000) / 60 >= 10) ? String(Math.round((miliSecs / 1000) / 60)) : "0" + String(Math.round((miliSecs / 1000) / 60))
			this.time_txt.text = String(mins + ":" + secs);
		}
		/*private function ioProgressHandler(evt:ProgressEvent):void {
			this.scroller_load_mc.scaleX = Math.round( evt.bytesLoaded / evt.bytesTotal);
			show_leng_time(_sound.length);
                }
		private function ioLoadedHandler(evt:Event):void {
			this.scroller_load_mc.scaleX = 1;
			show_leng_time(_sound.length);			
		}*/
		private function soundCompleteHandler(e: Event): void {
			this.scroller_play_mc.scaleX = 1;
			removeEventListener(Event.ENTER_FRAME, playingHandler);
			this.play_btn.visible = true;
			this.pause_btn.visible = false;
			_nextMal = true;
		}
		/** 
		 * end _sound события
		 ********************/


	}
}
