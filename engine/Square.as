package engine {
	import flash.display.Shape;

	public class Square extends Shape {
		public function Square	(	_positionX:Number,
									_positionY:Number,
									_size:uint,
									_bgColor:uint,
									_bgAlpha:Number,
									_borderColor:uint,
									_borderAlpha:uint,
									_borderSize:uint
								) {
			this.x = _positionX;
			this.y = _positionY;
			this.graphics.lineStyle(_borderSize,_borderColor,_borderAlpha);
			this.graphics.beginFill(_bgColor,_bgAlpha);
			this.graphics.drawRect(0,0,_size,_size);
			this.graphics.endFill();
/*			
			this.graphics.beginFill(0xffffff,_bgAlpha);
			this.graphics.drawRect(0,0,10,10);
			this.graphics.endFill();*/
		}
	}
}