package blocks {
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	ИМПОРТ ПАКЕТОВ																													//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import fl.transitions.easing.Strong;
	import flash.events.EventDispatcher;
	


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	КЛАСС - ИГРОВОЕ ПОЛЕ																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public class Field extends Block {
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		СВОЙСТВА КЛАССА																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// КОНСТАНТЫ
		private const _cellBackground:uint = 0x252525;
		private const _cellBorder:uint = 0x444444;
		// ПЕРЕМЕННЫЕ
		public var _cells:Array;
			
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КОНСТРУКТОР КЛАССА																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function Field() {
			// РИСУЕМ СЕТКУ
			this._cells = new Array();
			var _i:uint = new uint();
			var _j:uint = new uint();
			for ( _i ; _i < Block._fieldHeight; _i ++ ) {
				_j = 0;
				this._cells[_i] = new Array();
				for ( _j ; _j < Block._fieldWidth; _j ++ ) {
					this._cells[_i][_j] = new Cell	(	_j * Block._cellSize,
														_i * Block._cellSize,
														this._cellBackground,
														this._cellBorder,
														true
													);
					this.addChild(this._cells[_i][_j]);
				}
			}
			Block._eventDispatcher.addEventListener('BRICK_PRINTED',_brickFell);
		}
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КИРПИЧ УПАЛ																													//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _brickFell(_event:Event):void {
			var _i:uint = Block._fieldHeight;
			var _k:uint = new uint();
			for ( _i ; _i > _k ; _i -- ) {
				// КОЛ-ВО ВЫДЕЛЕННЫХ ЯЧЕЕК В СТРОКЕ
				var _selectedSquaresCount:uint = new uint();
				for ( var _j:String in this._cells[_i] ) {
					if ( this._cells[_i][_j]._status ) {
						_selectedSquaresCount ++;
					}
				}
				if ( _selectedSquaresCount == Block._fieldWidth ) {
					this._lineRemove ( _i );
					// ВОЗВРАЩАЕМСЯ НА ПРЕДЫДУЩУЮ СТРОКУ
					_i ++;
					// НО РАССМАТРИВАЕМ УЖЕ НА ОДНУ МЕНЬШЕ
					_k ++;
				}
			}
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ДВИГАЕМ СОДЕРЖИМОЕ СТАКАНА ВНИЗ																								//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _lineRemove (_line:uint):void {
			var _key:uint = _line - 1;
			
			for ( _key ; _key > 0 ; _key -- ) {
				for ( var _j:String in this._cells[_key] ) {
					if ( this._cells[_key][_j]._status ) {
						this._cells[_key + 1][_j]._stateChange('FILL');
					}
					else {
						this._cells[_key + 1][_j]._stateChange('EMPTY');
					}
					this._cells[_key][_j]._stateChange('EMPTY');
				}
			}
			Block._score += 1;
			Block._eventDispatcher.dispatchEvent(new Event('SCORE_CHANGED'));
			if ( Block._score % 1 == 0 && Block._score < 10 ) {
				Block._speed += 1;
				Block._eventDispatcher.dispatchEvent(new Event('SPEED_CHANGED'));
			}
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ОЧИЩАЕМ СТРОКУ																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _lineClear (_number:String):void {
			for ( var i:String in this._cells[_number] ) {
				this._cells[_number][i]._stateChange('EMPTY');
			}
		}
	}
}