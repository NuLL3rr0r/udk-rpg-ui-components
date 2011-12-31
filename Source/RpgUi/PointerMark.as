package RpgUi {
	import flash.display.Sprite;
	import flash.text.*;

	public class PointerMark extends Sprite {
		public function PointerMark(size:Number, color:Object, rightToLeft:Boolean) {
			super();
			this.graphics.clear();
			this.graphics.lineStyle(0, uint(color));
			this.graphics.beginFill(uint(color));
			if (rightToLeft) {
				this.graphics.moveTo(0.0, size / 2);
				this.graphics.lineTo(size, 0.0);
				this.graphics.lineTo(size, size);
				this.graphics.lineTo(0.0, size / 2);
			} else {
				this.graphics.moveTo(size, size / 2);
				this.graphics.lineTo(0.0, 0.0);
				this.graphics.lineTo(0.0, size);
				this.graphics.lineTo(size, size / 2);
			}
			this.graphics.endFill();
		}
	}
}
