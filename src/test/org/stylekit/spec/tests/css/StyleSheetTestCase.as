package org.stylekit.spec.tests.css
{
	
	import flexunit.framework.Assert;
	import flexunit.framework.AsyncTestHelper;
	
	import org.flexunit.async.Async;
	import org.stylekit.css.StyleSheet;
	import org.stylekit.css.StyleSheetCollection;
	import org.stylekit.css.parse.StyleSheetParser;
	import org.stylekit.css.style.Style;
	import org.stylekit.events.PropertyContainerEvent;
	import org.stylekit.events.StyleSheetEvent;
	import org.stylekit.spec.Fixtures;
	
	public class StyleSheetTestCase
	{
		protected var _styleSheet:StyleSheet;
		protected var _styles:Vector.<Style>;
		
		[Before]
		public function setUp():void
		{
			this._styleSheet = new StyleSheet;
			this._styles = new Vector.<Style>();
			for(var i:uint=0; i<5; i++)
			{
				this._styles.push(new Style(this._styleSheet));
			}
		}
		
		[After]
		public function tearDown():void
		{
			this._styleSheet = null;
			this._styles = null;
		}
		
		[Test(description="Ensures that addStyle enforces uniqueness of known styles, and that the correct event listeners are created")]
		public function addStyleEnforcesUniquenessAndListensForEvents():void
		{
			for(var i:uint=0; i < this._styles.length; i++)
			{
				var s:Style = this._styles[i];
			
				
				Assert.assertFalse(this._styleSheet.hasStyle(s));
				Assert.assertTrue(this._styleSheet.addStyle(s));
				Assert.assertTrue(this._styleSheet.hasStyle(s));
				


			}
		}
		
		[Test(description="Ensures that removeStyle removes the given style from the list and removes any event listeners on it")]
		public function removeStyleRemovesEventListners():void
		{
			for(var i:uint=0; i < this._styles.length; i++)
			{
				var s:Style = this._styles[i];
				Assert.assertFalse(this._styleSheet.hasStyle(s));
				Assert.assertFalse(this._styleSheet.removeStyle(s));
				Assert.assertTrue(this._styleSheet.addStyle(s));
				Assert.assertTrue(this._styleSheet.hasStyle(s));

				
				Assert.assertTrue(this._styleSheet.removeStyle(s));
				Assert.assertFalse(this._styleSheet.hasStyle(s));				

			}
		}
		
		[Test(async, description="Ensures that the StyleSheet dispatches a modified event when a Property mutates")]
		public function dispatchesEventsWhenPropertyMutates():void
		{
			var parser:StyleSheetParser = new StyleSheetParser();
			var parsed:StyleSheet = parser.parse(Fixtures.CSS_MIXED);
			
			var async:Function = Async.asyncHandler(this, this.onStyleSheetModified, 2000, { parsed: parsed }, this.onStyleSheetModifiedTimeout);
			
			parsed.addEventListener(StyleSheetEvent.STYLESHEET_MODIFIED, async);
			
			// toggle the first property on the first stylesheet to use important
			parsed.styles[0].properties[0].value.important = true;
		}
		
		protected function onStyleSheetModified(e:StyleSheetEvent, passThru:Object):void
		{
			Assert.assertTrue((passThru.parsed as StyleSheet).styles[0].properties[0].value.important);
		}
		
		protected function onStyleSheetModifiedTimeout(passThru:Object):void
		{
			Assert.fail("Timeout occured whilst waiting for a modification event from the StyleSheetCollection");
		}
	}
}