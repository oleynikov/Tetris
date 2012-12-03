package blocks {
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	ИМПОРТ ПАКЕТОВ																													//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	import engine.Square;
	import flash.events.EventDispatcher;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shape;


	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	КЛАСС - РОДИТЕЛЬ ВСЕХ КИРПИЧИКОВ																								//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public class Brick extends Block {



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		СВОЙСТВА КЛАССА																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// ВНЕШНИЕ
		public var _brickBlocks:Array;
		public var _blocksSprites:Array;
		// ВНУТРЕННИЕ

		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КОНСТРУКТОР КЛАССА																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function Brick() {
			// РИСУЕМ ФИГУРУ
			this._blocksSprites = new Array();
			for ( var i:String in this._brickBlocks ) {
				this._blocksSprites[i] = new Square	(	this._brickBlocks[i][0] * Block._cellSize,
														this._brickBlocks[i][1] * Block._cellSize,
														Block._cellSize,
														0x555555,
														1,
														0xaaaaaa,
														1,
														1
													);
				this.addChild(this._blocksSprites[i]);
			}
			
			
/*			var ox:Shape = new Shape();
				ox.graphics.lineStyle(1,0x00ff00,1);
				ox.graphics.moveTo(-2 * Block._cellSize,0);
				ox.graphics.lineTo(2 * Block._cellSize,0);
			this.addChild(ox);



			var oy:Shape = new Shape();
				oy.graphics.lineStyle(1,0xFFFFFF,1);
				oy.graphics.moveTo(0, -2 * Block._cellSize);
				oy.graphics.lineTo(0, 2 * Block._cellSize);
			this.addChild(oy);*/
		}
		


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ТОЛКАЕМ КУБИК																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _push (_direction:String):void {
			var _squaresLeft:uint = new uint();
			var _key:String = new String();
			switch ( _direction ) {
				case 'LEFT':
					for ( _key in this._brickBlocks ) {
						if ( this.x / Block._cellSize + this._brickBlocks[_key][0] <= 0 ) {
							_squaresLeft ++;
						}
					}
					if ( _squaresLeft == 0 ) {
						this.x -= Block._cellSize;
					}
					break;
				case 'RIGHT':
					for ( _key in this._brickBlocks ) {
						if ( this.x / Block._cellSize + this._brickBlocks[_key][0] >= Block._fieldWidth - 1 ) {
							_squaresLeft ++;
						}
					}
					if ( _squaresLeft == 0 ) {
						this.x += Block._cellSize;
					}
					break;
				case 'BOTTOM':
					// ПРОВЕРКА НА КОНЕЦ ЭКРАНА
					for ( _key in this._brickBlocks ) {
						if ( this.y / Block._cellSize + this._brickBlocks[_key][1] >= Block._fieldHeight - 1 ) {
							_squaresLeft ++;
						}
					}
					// КОНЕЦ ЭКРАНА НЕ ДОСТИГНУТ
					if ( _squaresLeft == 0 ) {
						this.y += Block._cellSize;
					}
					break;
			}
		}
		


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КРУТИМ КИРПИЧ																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _rotate (_field:Array):void {
			
		}
		


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ПРОВЕРЯЕМ ВСЕ КВАДРАТИКИ																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		protected function _squaresCheck (_newBrickBlocks:Array , _field:Array):Boolean {
			var _squareY:Number;
			var _squareX:Number;
			var _squaresLeft:uint;
			var _squaresField:uint;
			
			for ( var _key:String in _newBrickBlocks ) {
				_squareY = this.y / Block._cellSize + _newBrickBlocks[_key][1];
				_squareX = this.x / Block._cellSize + _newBrickBlocks[_key][0];
				if ( _squareX < 0 || _squareX > Block._fieldWidth - 1 || _squareY > Block._fieldHeight - 1 || _field[_squareY][_squareX]._status ) {
					_squaresLeft ++;
				}
			}
			if ( _squaresLeft == 0 ) {
				return true;
			}
			else {
				return false;
			}
		}		
	}
}