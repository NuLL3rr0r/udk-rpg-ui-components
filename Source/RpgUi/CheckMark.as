package RpgUi {
	import flash.display.Sprite;
	import flash.text.*;

	public class CheckMark extends Sprite {
		private static const CHECK_MARK_ASCII_CODE:Number = 252;

		public function CheckMark(fontSize:Object, color:Object, visibleMark:Boolean, markWidth:Number) {
			super();

			var font:WingdingsEmbeddedFont = new WingdingsEmbeddedFont();
			var format:TextFormat = new TextFormat();
			format.font = font.fontName;
			format.size = fontSize;
			format.color = color;

			var chk:TextField = new TextField();
			chk.text = visibleMark ? String.fromCharCode(CHECK_MARK_ASCII_CODE)
									: " ";
			chk.selectable = false;
			chk.embedFonts = true;
			chk.antiAliasType = AntiAliasType.ADVANCED;
			chk.setTextFormat(format);

			addChild(chk);
			chk.x = 0.0;
			chk.y = 0.0;
			chk.width = markWidth;
		}
	}
}
