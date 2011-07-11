
package ca.struct.icade
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 * @author Matt Rix - @MattRix - http://struct.ca
	 */

	public class iCadeManager
	{
		
		private static var _controls:Array;
		private static var _toggleControls:Array;
		private static var _isOn:Boolean = false;

		public static var stage:Stage;
		
		private static function setupControls():void
		{
			_controls = 
			[
				new Control("UP", 87, 69, "W", "E"),// WE 
				new Control("RIGHT", 68, 67, "D", "C"),// DC 
				new Control("DOWN", 88, 90, "X", "Z"),// XZ 
				new Control("LEFT", 65, 81, "A", "Q"),// AQ 
				new Control("A", 89, 84, "Y", "T"),// YT 
				new Control("B", 85, 70, "U", "F"),// UF 
				new Control("C", 73, 77, "I", "M"),// IM 
				new Control("D", 79, 71, "O", "G"),// OG 
				new Control("E", 72, 82, "H", "R"),// HR 
				new Control("F", 74, 78, "J", "N"),// JN 
				new Control("G", 75, 80, "K", "P"),// KP 
			];
			
			_toggleControls = [_controls[4], _controls[5], _controls[6], _controls[7]]; // Buttons ABCD (the top row)
		}

		public static function start(stage:Stage):void
		{
			iCadeManager.stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 1000);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 1000);
			setupControls();
			mapArrows();
		}


		public static function mapControl(keyCode:int, icadeControlName:String):void
		{
			for each (var control:Control in _controls)
			{
				if (control.name == icadeControlName)
				{
					if (control.keysToEmulate.indexOf(keyCode) == -1)
					{
						control.keysToEmulate.push(keyCode);
					}
				}
			}
		}

		public static function unmapControl(keyCode:int, icadeControlName:String):void
		{
			for each (var control:Control in _controls)
			{
				if (control.name == icadeControlName)
				{
					var keyIndex:int = control.keysToEmulate.indexOf(keyCode);
					if (keyIndex != -1)
					{
						control.keysToEmulate.splice(keyIndex, 1);
					}
				}
			}
		}

		public static function mapArrows():void
		{
			mapControl(38, "UP");
			mapControl(39, "RIGHT");
			mapControl(40, "DOWN");
			mapControl(37, "LEFT");
		}


		public static function unmapArrows():void
		{
			unmapControl(38, "UP");
			unmapControl(39, "RIGHT");
			unmapControl(40, "DOWN");
			unmapControl(37, "LEFT");
		}


		private static function onKeyDown(e:KeyboardEvent):void
		{
			if (e.keyLocation == 666) return;
			// don't listen to our own simulated keypresses

			for each (var control:Control in _controls)
			{
				if (control.downCode == e.keyCode)
				{
					if (!control.isDown)
					{
						control.isDown = true;

						if (!isOn)
						{
							if (areAllTogglesDown())
							{
								iCadeManager.isOn = true;
							}
						}
						else
						{
							if (areAllTogglesDown())
							{
								iCadeManager.isOn = false;
							}
							else
							{
								for each (var keyCode:int in control.keysToEmulate)
								{
									stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, keyCode, 666));
								}
							}
						}
					}
				}

				// don't let any other listeners use icade keys while icade is on
				if (isOn && (control.downCode == e.keyCode || control.upCode == e.keyCode))
				{
					e.stopImmediatePropagation();
				}
			}
		}

		private static function onKeyUp(e:KeyboardEvent):void
		{
			if (e.keyLocation == 666) return; //don't listen to our own simulated keypresses
			

			for each (var control:Control in _controls)
			{
				if (control.upCode == e.keyCode)
				{
					if (control.isDown)
					{
						control.isDown = false;
						if (isOn)
						{
							for each(var keyCode:int in control.keysToEmulate)
							{
								stage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 0, keyCode, 666));
							}
						}
					}
				}

				// don't let any other listeners use icade keys while icade is on
				if (isOn && (control.downCode == e.keyCode || control.upCode == e.keyCode))
				{
					e.stopImmediatePropagation();
				}
			}
		}

		private static function areAllTogglesDown():Boolean
		{
			for each (var control:Control in _toggleControls)
			{
				if (!control.isDown) return false;
			}
			return true;
		}

		private static function setAllControlsNotDown():void
		{
			for each (var control:Control in _controls)
			{
				control.isDown = false;
			}
		}

		// draw a joystick icon on screen for fun when icade is enabled :)
		private static function notifyUser():void
		{
			var size:Number = 150;
			var border:Number = 5;

			var popup:MovieClip = new MovieClip();
			var g:Graphics = popup.graphics;

			// outer border
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(-size / 2, -size / 2, size, size);
			g.endFill();

			// inner
			g.beginFill(0x000000, 1);
			g.drawRect(-size / 2 + border, -size / 2 + border, size - border * 2, size - border * 2);
			g.endFill();

			var joystick:Sprite = new Sprite();
			g = joystick.graphics;

			// base
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(0, 75, 100, 25);
			g.endFill();

			// ball
			g.beginFill(0xFFFFFF, 1);
			g.drawCircle(25, 25, 18);
			g.endFill();

			// stick
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(25 - 3, 12.5, 6, 75);
			g.endFill();

			// button1
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(50, 75 - 8, 20, 10);
			g.endFill();

			// button2
			g.beginFill(0xFFFFFF, 1);
			g.drawRect(75, 75 - 8, 20, 10);
			g.endFill();

			popup.addChild(joystick);
			joystick.x = -50;
			joystick.y = -50;

			stage.addChild(popup);
			popup.x = int(stage.stageWidth / 2);
			popup.y = int(stage.stageHeight / 2);

			if (isOn)
			{
				trace("iCadeManager is ON!");
			}
			else
			{
				trace("iCadeManager is OFF!");

				var ex:Sprite = new Sprite();
				g = ex.graphics;

				g.beginFill(0xFF0000, 1);
				g.drawRect(0 - 75, 70 - 75, 150, 10);
				g.endFill();

				g.beginFill(0xFF0000, 1);
				g.drawRect(70 - 75, 0 - 75, 10, 150);
				g.endFill();

				popup.addChild(ex);
				ex.rotation = 45;

			}

			popup.timer = 100;

			popup.addEventListener(Event.ENTER_FRAME, function(e:Event):void
			{
				if (!popup.parent) return;
				popup.timer -= 1;
				if (popup.timer <= 0)
				{
					popup.removeEventListener(Event.ENTER_FRAME, arguments.callee);
					popup.parent.removeChild(popup);
				}
			});


		}

		static public function get isOn():Boolean
		{
			return _isOn;
		}

		static public function set isOn(isOn:Boolean):void
		{
			if (_isOn != isOn)
			{
				_isOn = isOn;
				setAllControlsNotDown(); // make sure none of the buttons get stuck down
				notifyUser();
			}
		}

	}

}

internal class Control
{
	public var name:String;

	public var downCode:int;
	public var upCode:int;
	public var downChar:String;
	public var upChar:String;

	public var keysToEmulate:Array;

	public var isDown:Boolean;

	public function Control(name:String, downCode:int, upCode:int, downChar:String, upChar:String)
	{
		this.name = name;
		this.downCode = downCode;
		this.upCode = upCode;
		this.downChar = downChar;
		this.upChar = upChar;

		this.keysToEmulate = [];
		this.isDown = false;
	}

} 



