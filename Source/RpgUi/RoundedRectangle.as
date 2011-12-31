package RpgUi {
	import flash.display.Sprite;
	import flash.text.*;

	public class RoundedRectangle extends Sprite {
		public function RoundedRectangle(x:Number, y:Number, width:Number, height:Number, roundness:Number, color:Object) {
			super();
			this.graphics.clear();
			this.graphics.lineStyle(0, uint(color));
			this.graphics.beginFill(uint(color));
			this.graphics.drawRoundRect(x, y, width, height, roundness, roundness);
			this.graphics.endFill();
		}
	}
}
