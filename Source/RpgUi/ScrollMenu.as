package RpgUi {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.text.*;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import fl.transitions.*;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flashx.textLayout.elements.InlineGraphicElement;

	public class ScrollMenu extends Sprite {
		private var m_parentOfItems:ScrollMenuItemParent;

		private var m_colorDisabled:Object;
		private var m_colorEnabled:Object;
		private var m_colorSelected:Object;
		private var m_fontName:String;
		private var m_fontSize:Object;
		private var m_fontSizeSelected:Object;

		private var m_hasFocus:Boolean;
		private var m_hasSelectionChanged:Boolean;
		
		private var m_isRightToLeft:Boolean;

		private var m_isTransitioning:Boolean = false;

		private var m_items:Object;
		// This next line forces ScrollMenuItem to be compiled in, which
		// is necessary because being mentioned in the Collection
		// metadata does not necessarily do this.
		private var m_forceScrollMenuItem:ScrollMenuItem;

		private var m_isPointerMarkVisible:Boolean;

		private var m_motionBlur:Number;
		private var m_motionBlurQuality:int;

		private var m_pointer:PointerMark = null;

		private var m_spaceBetweenItems:Number;

		private var m_container:Sprite;

		private var m_stageItems:Sprite;
		private var m_stageItemsWidth:Number;

		private var m_transitionEasing:Function;
		private var m_transitionDuration:Number;

		[Inspectable(defaultValue="#999999" ,type="Color")]
		public function get ColorDisabled():Object {
			return m_colorDisabled;
		}
		public function set ColorDisabled(color:Object):void {
			m_colorDisabled = color;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="#333333", type="Color")]
		public function get ColorEnabled():Object {
			return m_colorEnabled;
		}
		public function set ColorEnabled(color:Object):void {
			m_colorEnabled = color;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="#000000", type="Color")]
		public function get ColorSelected():Object {
			return m_colorSelected;
		}
		public function set ColorSelected(color:Object):void {
			m_colorSelected = color;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="Verdana", type="Font Name")]
		public function get FontName():String {
			return m_fontName;
		}
		public function set FontName(name:String):void {
			m_fontName = name;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="24.0", type="Number")]
		public function get FontSize():Object {
			return m_fontSize;
		}
		public function set FontSize(size:Object):void {
			m_fontSize = size;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="30.0", type="Number")]
		public function get FontSizeSelected():Object {
			return m_fontSizeSelected;
		}
		public function set FontSizeSelected(name:Object):void {
			m_fontSizeSelected = name;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="false", type="Boolean")]
		public function get Focus():Boolean {
			return m_hasFocus;
		}
		public function set Focus(focus:Boolean):void {
			if (m_isTransitioning)
				return;
			
			m_hasFocus = focus;

			if (m_hasFocus) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
				stage.stageFocusRect = false;
				stage.focus = this;
			} else {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
			}
		}

		[Inspectable(defaultValue="true", type="Boolean")]
		public function get IsRightToLeft():Boolean {
			return m_isRightToLeft;
		}
		public function set IsRightToLeft(enabled:Boolean):void {
			m_isRightToLeft = enabled;
			SetParentOfItemsProperties();
			Draw();
		}

		[Collection(collectionClass="RpgUi.ScrollMenuCollection", collectionItem="RpgUi.ScrollMenuItem", identifier="id")]
		public function get Items():Object {
			return m_items;
		}
		public function set Items(items:Object):void {
			m_items = items;
			
			var hasSelected:Boolean = false;

			// This next line forces ScrollMenuCollection to be compiled in,
			// which is necessary because being mentioned in the Collection
			// metadata does not necessarily do this.
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;
			if (c != null) {
				for (var i:int = 0; i < c.length; i++) {
					var item:ScrollMenuItem = ScrollMenuItem(c.getItemAt(i));

					if (!hasSelected && item.IsEnabled) {
						SelectItem(item, true);
						hasSelected = true;
					}
						
					item.SetParent(m_parentOfItems);
				}
			}
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(defaultValue="3.0", type="Number")]
		public function get MotionBlur():Number {
			return m_motionBlur;
		}
		public function set MotionBlur(blur:Number):void {
			m_motionBlur = blur;
			SetParentOfItemsProperties();
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
			SetParentOfItemsProperties();
		}
		
		[Inspectable(defaultValue="true", type="Boolean")]
		public function get VisiblePointerMark():Boolean {
			return m_isPointerMarkVisible;
		}
		public function set VisiblePointerMark(visible:Boolean):void {
			m_isPointerMarkVisible = visible;
			Draw();
		}

		[Inspectable(defaultValue="40.0", type="Number")]
		public function get SpaceBetweenItems():Number {
			return m_spaceBetweenItems;
		}
		public function set SpaceBetweenItems(space:Number):void {
			m_spaceBetweenItems = space;
			SetParentOfItemsProperties();
			Draw();
		}

		[Inspectable(enumeration="Back.easeIn, Back.easeOut, Back.easeInOut, Bounce.easeIn, Bounce.easeOut, Bounce.easeInOut, Elastic.easeIn, Elastic.easeOut, Elastic.easeInOut, None.easeNone, None.easeIn, None.easeOut, None.easeInOut, Regular.easeIn, Regular.easeOut, Regular.easeInOut, Strong.easeIn, Strong.easeOut, Strong.easeInOut", defaultValue="Back.easeInOut", type="List")]
		public function get TransitionEasing():String {
			var ease:String;

			switch (m_transitionEasing) {
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
					ease = "Back.easeInOut";
					break;
			}
			
			return ease;
		}
		public function set TransitionEasing(ease:String):void {
			switch (ease) {
				case "Back.easeIn":
					m_transitionEasing = Back.easeIn;
					break;
				case "Back.easeOut":
					m_transitionEasing = Back.easeOut;
					break;
				case "Back.easeInOut":
					m_transitionEasing = Back.easeInOut;
					break;
				case "Bounce.easeIn":
					m_transitionEasing = Bounce.easeIn;
					break;
				case "Bounce.easeOut":
					m_transitionEasing = Bounce.easeOut;
					break;
				case "Bounce.easeInOut":
					m_transitionEasing = Bounce.easeInOut;
					break;
				case "Elastic.easeIn":
					m_transitionEasing = Elastic.easeIn;
					break;
				case "Elastic.easeOut":
					m_transitionEasing = Elastic.easeOut;
					break;
				case "Elastic.easeInOut":
					m_transitionEasing = Elastic.easeInOut;
					break;
				case "None.easeNone":
					m_transitionEasing = None.easeNone;
					break;
				case "None.easeIn":
					m_transitionEasing = None.easeIn;
					break;
				case "None.easeOut":
					m_transitionEasing = None.easeOut;
					break;
				case "None.easeInOut":
					m_transitionEasing = None.easeInOut;
					break;
				case "Regular.easeIn":
					m_transitionEasing = Regular.easeIn;
					break;
				case "Regular.easeOut":
					m_transitionEasing = Regular.easeOut;
					break;
				case "Regular.easeInOut":
					m_transitionEasing = Regular.easeInOut;
					break;
				case "Strong.easeIn":
					m_transitionEasing = Strong.easeIn;
					break;
				case "Strong.easeOut":
					m_transitionEasing = Strong.easeOut;
					break;
				case "Strong.easeInOut":
					m_transitionEasing = Strong.easeInOut;
					break;
				default:
					m_transitionEasing = Back.easeInOut;
					break;
			}
			SetParentOfItemsProperties();
		}

		[Inspectable(defaultValue="0.250", type="Number")]
		public function get TransitionDuration():Number {
			return m_transitionDuration;
		}
		public function set TransitionDuration(duration:Number):void {
			m_transitionDuration = duration;
			SetParentOfItemsProperties();
			Draw();
		}

		public function ScrollMenu() {
			super();
			Init();
		}
		
		public function AddItem(text:String, id:int = -1,
								colorDisabled:Object = null, colorEnabled:Object = null, colorSelected:Object = null,
								isChecked:Boolean = false, isEnabled = true):void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;
			if (c != null) {
				var item:ScrollMenuItem = new ScrollMenuItem();
				item.Text = text;
				if (id >= 0)
					item.Id = id;
				if (colorDisabled != "" && colorDisabled != null)
					item.ColorDisabled = colorDisabled;
				if (colorEnabled != "" && colorEnabled != null)
					item.ColorEnabled = colorEnabled;
				if (colorSelected != "" && colorSelected != null)
					item.ColorSelected = colorSelected;
				item.IsChecked = isChecked;
				item.IsEnabled = isEnabled;

				var hasSelected:Boolean = false;
				for (var i:int = 0; i < c.length; i++) {
					var tempItem:ScrollMenuItem = ScrollMenuItem(c.getItemAt(i));

					if (!hasSelected && tempItem.IsEnabled && tempItem.IsSelected) {
						hasSelected = true;
						break;
					}
				}

				if (!hasSelected)
					SelectItem(item, true);

				item.SetParent(m_parentOfItems);
				c.addItem(item);
				Draw();
			}
		}

		public function AddSeparator():void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;
			if (c != null) {
				var item:ScrollMenuItem = new ScrollMenuItem();
				item.Text = "--------";
				item.ColorDisabled = m_colorDisabled;
				item.IsEnabled = false;
				item.SetParent(m_parentOfItems);
				c.addItem(item);
			}
		}

		public function Clear():void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;
			if (c != null) {
				c.clear();
			}
			Draw();
		}

		private function SetPosition(item:ScrollMenuItem, xPos:Number, yPos:Number, lostSelection = false):void {
			if (!m_isRightToLeft)
				item.x = xPos;

			if (!item.IsSelected) {
				item.y = lostSelection ? item.y : yPos;
			}
			else {
				if (m_hasSelectionChanged) {
					item.y = item.y + ((m_pointer.height - item.Height) / 2.0);
					m_hasSelectionChanged = false;
				}
			}
		}

		private function FixRtlPosition(item:ScrollMenuItem):void {
			if (m_isRightToLeft) {
				item.x = m_stageItems.width - item.width;
			}
		}

		private function Draw():void {
			for (var p:Number = 0; p < m_container.numChildren; ++p) {
				if (m_container.getChildAt(p) is PointerMark) {
					m_container.removeChildAt(p);
					m_pointer = new PointerMark(Number(m_fontSize), m_colorSelected, m_isRightToLeft);
					m_container.addChild(m_pointer);
					m_pointer.y = 0.0;
					if (m_isRightToLeft) {
						m_pointer.x = this.width - Number(m_fontSize);
					} else {
						m_pointer.x = 0.0;
					}
					break;
				}
			}

			m_pointer.visible = m_isPointerMarkVisible;

			while (m_stageItems.numChildren > 0) {
				m_stageItems.removeChildAt(0);
			}

			var yPos:int = 0;

			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;
			if (c != null) {
				var i:int = 0;
				var enabledIndex:int = 0;
				var item:ScrollMenuItem;

				for (i = 0; i < c.length; i++) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.IsEnabled) {
						enabledIndex = i;
						break;
					}
				}
				yPos = -(m_spaceBetweenItems * enabledIndex);

				for (i = 0; i < c.length; i++) {
					item = ScrollMenuItem(c.getItemAt(i));

					item.Draw();
					m_stageItems.addChild(item);
					
					if (!item.IsEnabled)
						item.IsSelected = false;

					if (i < enabledIndex)
						SetPosition(item, 0, yPos + ((m_pointer.height - ScrollMenuItem(c.getItemAt(enabledIndex)).Height) / 2.0));
					else
						SetPosition(item, 0, yPos);

					yPos += m_spaceBetweenItems;
				}
			}

			m_stageItemsWidth = m_stageItems.width;

			if (m_isRightToLeft) {
				for (var j:Number = 0; j < m_stageItems.numChildren; ++j) {
					if (m_stageItems.getChildAt(j) is ScrollMenuItem) {
						FixRtlPosition(ScrollMenuItem(m_stageItems.getChildAt(j)));
					}
				}

				m_stageItems.x = m_pointer.x - m_stageItems.width;
			}
			else
				m_stageItems.x = Number(m_fontSize);
				
			m_stageItems.y = 0.0;
		}

		private function Init():void {
			m_parentOfItems = new ScrollMenuItemParent();

			m_colorDisabled = 0x999999;
			m_colorEnabled = 0x333333;
			m_colorSelected = 0x000000;
			m_fontName = 'Verdana';
			m_fontSize = 24.0;
			m_fontSizeSelected = 30.0;

			m_hasFocus = false;
			m_isPointerMarkVisible = true;
			m_isRightToLeft = true;

			m_items = new ScrollMenuCollection();

			m_motionBlur = 3.0;
			m_motionBlurQuality = BitmapFilterQuality.MEDIUM;

			m_spaceBetweenItems = 40.0;

			m_transitionEasing = Back.easeInOut;
			m_transitionDuration = 0.250;

			m_container = new Sprite();
			m_pointer = new PointerMark(Number(m_fontSize), m_colorSelected, m_isRightToLeft);
			m_container.addChild(m_pointer);

			m_stageItems = new Sprite();
			m_container.addChild(m_stageItems);

			this.getChildAt(0).visible = false;

			this.addChild(m_container);
			m_container.scaleX = 1.0 / this.scaleX;
			m_container.scaleY = 1.0 / this.scaleY;

			Draw();
		}

		private function KeyDownHandler(e:KeyboardEvent):void {
			if (!m_hasFocus)
				return;

			switch (e.keyCode) {
				case 32:
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
					MenuItemPressed();
					break;
				case 38:
				case 87:
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
					SelectPrevItem();
					break;
				case 40:
				case 83:
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
					SelectNextItem();
					break;
				default:
					stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
					break;
			}
		}

		private function MenuItemPressed():void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;

			if (c != null) {
				var item:ScrollMenuItem;
				for (var i:int = 0; i < c.length; i++) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.IsSelected) {
						OnMenuItemPressed(item);
						break;
					}
				}
			}

			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
		}

		private function OnMenuItemPressed(item:ScrollMenuItem):void {
			dispatchEvent(new ScrollMenuEvent(ScrollMenuEvent.ITEM_SELECTED, item));
		}

		public function GetItemById(id:int):ScrollMenuItem {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;

			if (c != null) {
				var item:ScrollMenuItem;
				for (var i:int = 0; i < c.length; i++) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.Id == id) {
						return item;
					}
				}
			}

			return null;
		}

		public function SelectItemById(id:int):void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;

			if (c != null) {
				var item:ScrollMenuItem;
				var selectedIndex:int = 0;;
				var yPos:int = 0;
				var i:int;
				for (i = 0; i < c.length; i++) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.Id == id) {
						selectedIndex = i;
						SelectItem(item, true);
					} else {
						SelectItem(item, false);
					}
				}

				yPos = -(m_spaceBetweenItems * selectedIndex);

				for (i = 0; i < c.length; i++) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (!item.IsSelected) {
						item.y = yPos;
					} else {
						item.y = yPos + ((m_pointer.height - item.Height) / 2.0);
					}
					yPos += m_spaceBetweenItems;
				}
			}

			var selectedItem:ScrollMenuItem = ScrollMenuItem(c.getItemAt(id));

			if (selectedItem == null)
				return;

			for (i = selectedIndex - 1; i > -1; --i) {
				item = ScrollMenuItem(c.getItemAt(i));
				SetPosition(item, item.x, item.y + ((m_pointer.height - selectedItem.Height) / 2.0));
			}
		}

		public function SelectItem(item:ScrollMenuItem, select:Boolean):void {
			if (m_isRightToLeft) {
				var wBefore:Number;
				var wAfter:Number;

				wBefore = item.width;
				item.IsSelected = select;
				wAfter = item.width;

				item.x += wBefore - wAfter;
			} else {
				item.IsSelected = select;
			}

			if (select) {
				m_hasSelectionChanged = true;
				dispatchEvent(new ScrollMenuEvent(ScrollMenuEvent.ITEM_ROLL_OVER, item));
			} else {
				m_hasSelectionChanged = false;
			}
		}

		private function SetBlurFilter(amount:Number):void {
			if (amount > 0.0) {
				var blur:BlurFilter = new BlurFilter();
				blur.blurX = 0.0;
				blur.blurY = amount;
				blur.quality = m_motionBlurQuality;
				m_stageItems.filters = [blur];
			}
			else {
				m_stageItems.filters = [];
			}
		}

		private function OnTransitionStart(event:TweenEvent):void {
			m_isTransitioning = true;
			SetBlurFilter(m_motionBlur);
		}

		private function OnTransitionStop(event:TweenEvent):void {
			m_isTransitioning = false;
			SetBlurFilter(0.0);

			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
		}

		// fix for flash gc bug
		var tween:Tween = null;
		private function MoveTo(dir:Number):void {
			var diff:Number = 0.0;
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;

			if (c != null) {
				for (var i:int = 0; i < c.length; i++) {
					var item:ScrollMenuItem = ScrollMenuItem(c.getItemAt(i));
					if (item.IsSelected) {
						while (i < c.length || i > 0) {
							var nextItem:ScrollMenuItem = ScrollMenuItem(c.getItemAt(i - dir));

							if (nextItem == null) {
								stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
								return;
							}

							if (nextItem.IsEnabled) {
								diff = item.y - nextItem.y - ((m_pointer.height - item.Height) / 2.0);
								break;
							}
							i -= dir;
						}
						break;
					}
				}
			}

			tween = new Tween(m_stageItems, "y", m_transitionEasing, m_stageItems.y,
										m_stageItems.y + diff, m_transitionDuration, true);
			tween.addEventListener(TweenEvent.MOTION_CHANGE, OnTransitionStart);
	        tween.addEventListener(TweenEvent.MOTION_FINISH, OnTransitionStop);
		}

		private function NavigateDown():void {
			MoveTo(-1);
		}

		private function NavigateUp():void {
			MoveTo(1);
		}

		private function SelectNextItem():void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;

			if (c != null) {
				var item:ScrollMenuItem = ScrollMenuItem(c.getItemAt(c.length - 1));

				if (item.IsSelected) {
					stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
					return;
				}

				NavigateDown();

				var lastEnabledItemIndex:int = -1;
				for (var i:int = 0; i < c.length; ++i) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.IsEnabled) {
						lastEnabledItemIndex = i;
					}
				}

				for (i = 0; i < c.length; ++i) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.IsSelected) {
						var nextItem:ScrollMenuItem;
						for (var j:int = i + 1; j < c.length; ++j) {
							nextItem = ScrollMenuItem(c.getItemAt(j));
							if (nextItem.IsEnabled) {
								SelectItem(item, false);
								SelectItem(nextItem, true);
								SetPosition(item, item.x, item.y, true);
								SetPosition(nextItem, nextItem.x, nextItem.y);
								break;
							} else {
								if (i < lastEnabledItemIndex) {
									SetPosition(nextItem, nextItem.x, nextItem.y + ((m_pointer.height - item.Height) / 2.0), false);
								}
							}
						}
						break;
					}
				}
			}
		}

		private function SelectPrevItem():void {
			var c:ScrollMenuCollection = m_items as ScrollMenuCollection;

			if (c != null) {
				var item:ScrollMenuItem = ScrollMenuItem(c.getItemAt(0));

				if (item.IsSelected) {
					stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDownHandler);
					return;
				}

				NavigateUp();

				var selectedItemIndex:int = -1;
				var deselectedItemIndex:int = -1;

				for (var i:int = 0; i < c.length; ++i) {
					item = ScrollMenuItem(c.getItemAt(i));
					if (item.IsSelected) {
						var prevItem:ScrollMenuItem;
						deselectedItemIndex = i;
						for (var j:int = i - 1; j > -1; --j) {
							prevItem = ScrollMenuItem(c.getItemAt(j));
							if (prevItem.IsEnabled) {
								selectedItemIndex = j;
								SelectItem(item, false);
								SelectItem(prevItem, true);
								SetPosition(item, item.x, item.y, true);
								SetPosition(prevItem, prevItem.x, prevItem.y);
								break;
							}
						}
						break;
					}
				}

				var selectedItem:ScrollMenuItem = ScrollMenuItem(c.getItemAt(selectedItemIndex));

				if (selectedItem == null)
					return;

				for (i = selectedItemIndex + 1; i < c.length; ++i) {
					if (i != deselectedItemIndex) {
						item = ScrollMenuItem(c.getItemAt(i));
						SetPosition(item, item.x, item.y + ((m_pointer.height - selectedItem.Height) / 2.0));
						if (!item.IsEnabled && selectedItemIndex < i && deselectedItemIndex > i) {
							SetPosition(item, item.x, item.y - ((m_pointer.height - selectedItem.Height) / 2.0));
						}
					}
				}
				for (i = selectedItemIndex - 1; i > -1; --i) {
					item = ScrollMenuItem(c.getItemAt(i));
					SetPosition(item, item.x, item.y + ((m_pointer.height - selectedItem.Height) / 2.0));
				}
			}
		}

		private function SetParentOfItemsProperties():void {
			m_parentOfItems.ColorDisabled = m_colorDisabled;
			m_parentOfItems.ColorEnabled = m_colorEnabled;
			m_parentOfItems.ColorSelected = m_colorSelected;
			m_parentOfItems.FontName = m_fontName;
			m_parentOfItems.FontSize = m_fontSize;
			m_parentOfItems.FontSizeSelected = m_fontSizeSelected;
			m_parentOfItems.IsRightToLeft = m_isRightToLeft;
		}
	}
}
