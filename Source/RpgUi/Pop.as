package RpgUi {
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.text.*;
    import flash.utils.Timer;
    import flash.utils.*;

	public class Pop extends Sprite {
		private var m_movieClipClass:String;
		private var m_movieClip:MovieClip = null;
		private var m_motionBlur:Number;
		private var m_motionBlurQuality:int;
		private var m_popupTimeOut:Number;
		private var m_transitionEasingAppear:Function;
		private var m_transitionEasingDisappear:Function;
		private var m_transitionEffectAppear:String;
		private var m_transitionEffectDisappear:String;
		private var m_transitionDurationAppear:Number;
		private var m_transitionDurationDisappear:Number;
		private var m_transitionIrishEffectShapeAppear:String;
		private var m_transitionIrishEffectShapeDisappear:String;

		private var m_container:MovieClip = null;

		[Inspectable(defaultValue="", type="String")]
		public function get MovieClipClass():String {
			return m_movieClipClass;
		}
		public function set MovieClipClass(mc:String):void {
			m_movieClipClass = mc;
			InitMovieClip();
			Draw();
		}

		[Inspectable(defaultValue="3.0", type="Number")]
		public function get MotionBlur():Number {
			return m_motionBlur;
		}
		public function set MotionBlur(blur:Number):void {
			m_motionBlur = blur;
		}

		[Inspectable(enumeration="Low, Medium, High", defaultValue="Medium", type="List")]
		public function get MotionBlurQuality():String {
			var quality:String;

			switch (m_motionBlurQuality) {
				case BitmapFilterQuality.LOW:
					quality = "Low";
					break;
				case BitmapFilterQuality.MEDIUM:
					quality = "Medium";
					break;
				case BitmapFilterQuality.HIGH:
					quality = "High";
					break;
				default:
					quality = "Medium";
					break;
			}
			
			return quality;
		}
		public function set MotionBlurQuality(quality:String):void {
			switch (quality) {
				case "Low":
					m_motionBlurQuality = BitmapFilterQuality.LOW;
					break;
				case "Medium":
					m_motionBlurQuality = BitmapFilterQuality.MEDIUM;
					break;
				case "High":
					m_motionBlurQuality = BitmapFilterQuality.HIGH;
					break;
				default:
					m_motionBlurQuality = BitmapFilterQuality.MEDIUM;
					break;
			}
		}

		[Inspectable(defaultValue="5.0", type="Number")]
		public function get PopupTimeOut():Number {
			return m_popupTimeOut;
		}
		public function set PopupTimeOut(time:Number):void {
			m_popupTimeOut = time;
		}

		[Inspectable(enumeration="Back.easeIn, Back.easeOut, Back.easeInOut, Bounce.easeIn, Bounce.easeOut, Bounce.easeInOut, Elastic.easeIn, Elastic.easeOut, Elastic.easeInOut, None.easeNone, None.easeIn, None.easeOut, None.easeInOut, Regular.easeIn, Regular.easeOut, Regular.easeInOut, Strong.easeIn, Strong.easeOut, Strong.easeInOut", defaultValue="Regular.easeIn", type="List")]
		public function get TransitionEasingAppear():String {
			var ease:String;

			switch (m_transitionEasingAppear) {
				case Back.easeIn:
					ease = "Back.easeIn";
					break;
				case Back.easeOut:
					ease = "Back.easeOut";
					break;
				case Back.easeInOut:
					ease = "Back.easeInOut";
					break;
				case Bounce.easeIn:
					ease = "Bounce.easeIn";
					break;
				case Bounce.easeOut:
					ease = "Bounce.easeOut";
					break;
				case Bounce.easeInOut:
					ease = "Bounce.easeInOut";
					break;
				case Elastic.easeIn:
					ease = "Elastic.easeIn";
					break;
				case Elastic.easeOut:
					ease = "Elastic.easeOut";
					break;
				case Elastic.easeInOut:
					ease = "Elastic.easeInOut";
					break;
				case None.easeNone:
					ease = "None.easeNone";
					break;
				case None.easeIn:
					ease = "None.easeIn";
					break;
				case None.easeOut:
					ease = "None.easeOut";
					break;
				case None.easeInOut:
					ease = "None.easeInOut";
					break;
				case Regular.easeIn:
					ease = "Regular.easeIn";
					break;
				case Regular.easeOut:
					ease = "Regular.easeOut";
					break;
				case Regular.easeInOut:
					ease = "Regular.easeInOut";
					break;
				case Strong.easeIn:
					ease = "Strong.easeIn";
					break;
				case Strong.easeOut:
					ease = "Strong.easeOut";
					break;
				case Strong.easeInOut:
					ease = "Strong.easeInOut";
					break;
				default:
					ease = "Regular.easeIn";
					break;
					break;
			}
			
			return ease;
		}
		public function set TransitionEasingAppear(ease:String):void {
			switch (ease) {
				case "Back.easeIn":
					m_transitionEasingAppear = Back.easeIn;
					break;
				case "Back.easeOut":
					m_transitionEasingAppear = Back.easeOut;
					break;
				case "Back.easeInOut":
					m_transitionEasingAppear = Back.easeInOut;
					break;
				case "Bounce.easeIn":
					m_transitionEasingAppear = Bounce.easeIn;
					break;
				case "Bounce.easeOut":
					m_transitionEasingAppear = Bounce.easeOut;
					break;
				case "Bounce.easeInOut":
					m_transitionEasingAppear = Bounce.easeInOut;
					break;
				case "Elastic.easeIn":
					m_transitionEasingAppear = Elastic.easeIn;
					break;
				case "Elastic.easeOut":
					m_transitionEasingAppear = Elastic.easeOut;
					break;
				case "Elastic.easeInOut":
					m_transitionEasingAppear = Elastic.easeInOut;
					break;
				case "None.easeNone":
					m_transitionEasingAppear = None.easeNone;
					break;
				case "None.easeIn":
					m_transitionEasingAppear = None.easeIn;
					break;
				case "None.easeOut":
					m_transitionEasingAppear = None.easeOut;
					break;
				case "None.easeInOut":
					m_transitionEasingAppear = None.easeInOut;
					break;
				case "Regular.easeIn":
					m_transitionEasingAppear = Regular.easeIn;
					break;
				case "Regular.easeOut":
					m_transitionEasingAppear = Regular.easeOut;
					break;
				case "Regular.easeInOut":
					m_transitionEasingAppear = Regular.easeInOut;
					break;
				case "Strong.easeIn":
					m_transitionEasingAppear = Strong.easeIn;
					break;
				case "Strong.easeOut":
					m_transitionEasingAppear = Strong.easeOut;
					break;
				case "Strong.easeInOut":
					m_transitionEasingAppear = Strong.easeInOut;
					break;
				default:
					m_transitionEasingAppear = Back.easeInOut;
					break;
			}
		}

		[Inspectable(enumeration="Back.easeIn, Back.easeOut, Back.easeInOut, Bounce.easeIn, Bounce.easeOut, Bounce.easeInOut, Elastic.easeIn, Elastic.easeOut, Elastic.easeInOut, None.easeNone, None.easeIn, None.easeOut, None.easeInOut, Regular.easeIn, Regular.easeOut, Regular.easeInOut, Strong.easeIn, Strong.easeOut, Strong.easeInOut", defaultValue="Regular.easeOut", type="List")]
		public function get TransitionEasingDisappear():String {
			var ease:String;

			switch (m_transitionEasingDisappear) {
				case Back.easeIn:
					ease = "Back.easeIn";
					break;
				case Back.easeOut:
					ease = "Back.easeOut";
					break;
				case Back.easeInOut:
					ease = "Back.easeInOut";
					break;
				case Bounce.easeIn:
					ease = "Bounce.easeIn";
					break;
				case Bounce.easeOut:
					ease = "Bounce.easeOut";
					break;
				case Bounce.easeInOut:
					ease = "Bounce.easeInOut";
					break;
				case Elastic.easeIn:
					ease = "Elastic.easeIn";
					break;
				case Elastic.easeOut:
					ease = "Elastic.easeOut";
					break;
				case Elastic.easeInOut:
					ease = "Elastic.easeInOut";
					break;
				case None.easeNone:
					ease = "None.easeNone";
					break;
				case None.easeIn:
					ease = "None.easeIn";
					break;
				case None.easeOut:
					ease = "None.easeOut";
					break;
				case None.easeInOut:
					ease = "None.easeInOut";
					break;
				case Regular.easeIn:
					ease = "Regular.easeIn";
					break;
				case Regular.easeOut:
					ease = "Regular.easeOut";
					break;
				case Regular.easeInOut:
					ease = "Regular.easeInOut";
					break;
				case Strong.easeIn:
					ease = "Strong.easeIn";
					break;
				case Strong.easeOut:
					ease = "Strong.easeOut";
					break;
				case Strong.easeInOut:
					ease = "Strong.easeInOut";
					break;
				default:
					ease = "Regular.easeOut";
					break;
			}

			return ease;
		}
		public function set TransitionEasingDisappear(ease:String):void {
			switch (ease) {
				case "Back.easeIn":
					m_transitionEasingDisappear = Back.easeIn;
					break;
				case "Back.easeOut":
					m_transitionEasingDisappear = Back.easeOut;
					break;
				case "Back.easeInOut":
					m_transitionEasingDisappear = Back.easeInOut;
					break;
				case "Bounce.easeIn":
					m_transitionEasingDisappear = Bounce.easeIn;
					break;
				case "Bounce.easeOut":
					m_transitionEasingDisappear = Bounce.easeOut;
					break;
				case "Bounce.easeInOut":
					m_transitionEasingDisappear = Bounce.easeInOut;
					break;
				case "Elastic.easeIn":
					m_transitionEasingDisappear = Elastic.easeIn;
					break;
				case "Elastic.easeOut":
					m_transitionEasingDisappear = Elastic.easeOut;
					break;
				case "Elastic.easeInOut":
					m_transitionEasingDisappear = Elastic.easeInOut;
					break;
				case "None.easeNone":
					m_transitionEasingDisappear = None.easeNone;
					break;
				case "None.easeIn":
					m_transitionEasingDisappear = None.easeIn;
					break;
				case "None.easeOut":
					m_transitionEasingDisappear = None.easeOut;
					break;
				case "None.easeInOut":
					m_transitionEasingDisappear = None.easeInOut;
					break;
				case "Regular.easeIn":
					m_transitionEasingDisappear = Regular.easeIn;
					break;
				case "Regular.easeOut":
					m_transitionEasingDisappear = Regular.easeOut;
					break;
				case "Regular.easeInOut":
					m_transitionEasingDisappear = Regular.easeInOut;
					break;
				case "Strong.easeIn":
					m_transitionEasingDisappear = Strong.easeIn;
					break;
				case "Strong.easeOut":
					m_transitionEasingDisappear = Strong.easeOut;
					break;
				case "Strong.easeInOut":
					m_transitionEasingDisappear = Strong.easeInOut;
					break;
				default:
					m_transitionEasingDisappear = Back.easeInOut;
					break;
			}
		}

		[Inspectable(enumeration="Blinds, Fade, Fly, Iris, PixelDissolve, Photo, Rotate, Squeeze, Wipe, Zoom", defaultValue="Zoom", type="List")]
		public function get TransitionEffectAppear():String {
			return m_transitionEffectAppear;
		}
		public function set TransitionEffectAppear(effect:String):void {
			m_transitionEffectAppear = effect
		}

		[Inspectable(enumeration="Blinds, Fade, Fly, Iris, PixelDissolve, Photo, Rotate, Squeeze, Wipe, Zoom", defaultValue="Fly", type="List")]
		public function get TransitionEffectDisappear():String {
			return m_transitionEffectDisappear;
		}
		public function set TransitionEffectDisappear(effect:String):void {
			m_transitionEffectDisappear = effect;
		}

		[Inspectable(defaultValue="1.0", type="Number")]
		public function get TransitionDurationAppear():Number {
			return m_transitionDurationAppear;
		}
		public function set TransitionDurationAppear(duration:Number):void {
			m_transitionDurationAppear = duration;
		}

		[Inspectable(defaultValue="1.0", type="Number")]
		public function get TransitionDurationDisappear():Number {
			return m_transitionDurationDisappear;
		}
		public function set TransitionDurationDisappear(duration:Number):void {
			m_transitionDurationDisappear = duration;
		}

		[Inspectable(enumeration="CIRCLE, SQUARE", defaultValue="CIRCLE", type="List")]
		public function get TransitionIrishEffectShapeAppear():String {
			return m_transitionIrishEffectShapeAppear;
		}
		public function set TransitionIrishEffectShapeAppear(shape:String):void {
			m_transitionIrishEffectShapeAppear = shape;
		}

		[Inspectable(enumeration="CIRCLE, SQUARE", defaultValue="SQUARE", type="List")]
		public function get TransitionIrishEffectShapeDisappear():String {
			return m_transitionIrishEffectShapeDisappear;
		}
		public function set TransitionIrishEffectShapeDisappear(shape:String):void {
			m_transitionIrishEffectShapeDisappear = shape;
		}

		public function Pop() {
			super();
			Init();
		}

		private function InitMovieClip() {
			if (m_container != null) {
				while (m_container.numChildren > 0) {
					m_container.removeChildAt(0);
				}
				if (m_movieClipClass != "") {
					var mcClass = getDefinitionByName(Trim(m_movieClipClass)) as Class;
					m_movieClip = new mcClass();
					m_container.addChild(m_movieClip);
				}
			}
		}

		public function Popup() {
			this.visible = true;
			StartInTransition();
		}
		
		public function Popout() {
			StartOutTransition();
		}

		private function Init():void {
			m_movieClipClass = "";

			m_motionBlur = 3.0;
			m_motionBlurQuality = BitmapFilterQuality.MEDIUM;
			m_popupTimeOut = 5.0;

			m_transitionEasingAppear = Back.easeInOut;
			m_transitionEasingDisappear = Back.easeInOut;
			m_transitionEffectAppear = "Zoom";
			m_transitionEffectDisappear = "Fly";
			m_transitionDurationAppear = 1.0;
			m_transitionDurationDisappear = 1.0;
			m_transitionIrishEffectShapeAppear = Iris.CIRCLE;
			m_transitionIrishEffectShapeDisappear = Iris.SQUARE;

			this.getChildAt(0).visible = false;
			m_container = new MovieClip();

			this.addChild(m_container);
			m_container.scaleX = 1.0 / this.scaleX;
			m_container.scaleY = 1.0 / this.scaleY;

			InitMovieClip();

			Draw();
		}

		private function Draw():void {
			this.visible = false;
			if (m_movieClip != null) {
				m_movieClip.x = 0.0;
				m_movieClip.y = 0.0;
			}
		}

		private function GetEffectClass(effect:String):Class {
			switch (effect) {
				case "Blinds":
					return Blinds;
				case "Fade":
					return Fade;
				case "Fly":
					return Fly;
				case "Iris":
					return Iris;
				case "PixelDissolve":
					return PixelDissolve;
				case "Photo":
					return Photo;
				case "Rotate":
					return Rotate;
				case "Squeeze":
					return Squeeze;
				case "Wipe":
					return Wipe;
				case "Zoom":
					return Zoom;
				default:
					return Zoom;
			}
		}

		private function SetBlurFilter(amount:Number):void {
			if (amount > 0.0) {
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = amount;
				blur.blurY = 0.0;
				blur.quality = m_motionBlurQuality;
				m_container.filters = [blur];
			}
			else {
				m_container.filters = [];
			}
		}

		private function StartInTransition():void {
			dispatchEvent(new PopEvent(PopEvent.POPUP, m_movieClipClass));

			SetBlurFilter(m_motionBlur);

			var transitions:Array = new Array();

			var transitionManager:TransitionManager = new TransitionManager(m_container);
			transitionManager.startTransition({ type:GetEffectClass(m_transitionEffectAppear), direction:Transition.IN,
											  		duration:m_transitionDurationAppear, easing:m_transitionEasingAppear, shape:m_transitionIrishEffectShapeAppear });
			transitions.push(transitionManager);

			transitionManager.addEventListener("allTransitionsInDone", OnInTransitionCompleted);
		}

		private function StartOutTransition(event:TimerEvent = null):void {
			SetBlurFilter(m_motionBlur);

			var transitions:Array = new Array();

			var transitionManager:TransitionManager = new TransitionManager(m_container);
			transitionManager.startTransition({ type:GetEffectClass(m_transitionEffectDisappear), direction:Transition.OUT,
											  		duration:m_transitionDurationDisappear, easing:m_transitionEasingDisappear, shape:m_transitionIrishEffectShapeDisappear });
			transitions.push(transitionManager);

			transitionManager.addEventListener("allTransitionsOutDone", OnOutTransitionCompleted);
		}

		function OnInTransitionCompleted(e:Event):void {
			SetBlurFilter(0.0);

			if (m_popupTimeOut != 0.0) {
				var timer:Timer = new Timer(m_popupTimeOut * 1000.0, 1);
				timer.addEventListener(TimerEvent.TIMER, StartOutTransition);
				timer.start();
			}
		}

		function OnOutTransitionCompleted(e:Event):void {
			this.visible = false;
			SetBlurFilter(0.0);

			dispatchEvent(new PopEvent(PopEvent.POPOUT, m_movieClipClass));
		}

		private function TrimBack(str:String):String {
			if (str.charAt(str.length - 1) == " ")
				str = TrimBack(str.substring(0, str.length - 1));
			return str;
		}

		private function TrimFront(str:String):String {
			if (str.charAt(0) == " ")
				str = TrimFront(str.substring(1));
			return str;
		}

		private function Trim(str:String):String {
			return TrimBack(TrimFront(str));
		}

		public function GetMovieClipInstance():MovieClip {
			return m_movieClip;
		}
	}
}

