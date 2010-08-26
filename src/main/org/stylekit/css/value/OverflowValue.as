package org.stylekit.css.value
{
	import org.utilkit.util.StringUtil;

	public class OverflowValue extends Value
	{
		public static var OVERFLOW_VISIBLE:uint = 0;
		public static var OVERFLOW_HIDDEN:uint = 1;
		public static var OVERFLOW_SCROLL:uint = 2;
		public static var OVERFLOW_AUTO:uint = 3;
		public static var OVERFLOW_INHERIT:uint = 4;
		
		protected var _overflow:uint = OverflowValue.OVERFLOW_VISIBLE;
		
		protected static var validStrings:Array = [
			"visible", "hidden", "scroll", "auto", "inherit"
		];
		
		public function OverflowValue()
		{
			super();
		}
		
		public function get overflow():uint
		{
			return this._overflow;
		}
		
		public function set overflow(overflow:uint):void
		{
			this._overflow = overflow;
		}
		
		public static function parse(str:String):OverflowValue
		{
			str = StringUtil.trim(str).toLowerCase();
			
			var value:OverflowValue = new OverflowValue();
			value.rawValue = str;
			
			value.overflow = Math.max(0, OverflowValue.validStrings.indexOf(str));
			
			return value;
		}
	}
}