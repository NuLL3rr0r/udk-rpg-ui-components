package RpgUi {
	import flash.events.Event;

	public class QuestNotifyEvent extends Event {

		public static const NOTIFY_RAISED:String = "notifyRaised";
		public static const NOTIFY_DONE:String = "notifyDone";

		protected var m_notify:String;

		public function get Notify():String {
            return m_notify;
        }
 
        public function set Notify(value:String):void {
             m_notify = value;
        }

		public function QuestNotifyEvent(type:String, notify:String = "") {
			super(type);
			
			m_notify = notify;
		}

		override public function toString():String {
			return formatToString("QuestNotifyEvent", "type", "notify");
		}

		override public function clone():Event {
			return new QuestNotifyEvent(type, m_notify);
		}
	}
}
