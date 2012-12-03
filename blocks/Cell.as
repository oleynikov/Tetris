﻿package blocks{



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	ИМПОРТ ПАКЕТОВ																													//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	import engine.Square;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КЛАСС - ЯЧЕЙКА ИГРОВОГО ПОЛЯ																								//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public class Cell extends Block {



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		СВОЙСТВА КЛАССА																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// ВНЕШНИЕ
		public var _status:Boolean;
		// ВНУТРЕННИЕ
		private var _shape:Shape;
		private var _background:uint;
		private var _border:uint;



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КОНСТРУКТОР КЛАССА																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function Cell	(	_positionX:uint,
									_positionY:uint,
									_background:uint,
									_border:uint,
									_status:Boolean
								) {
			// ИНИЦИАЛИЗИРУЕМ ПЕРЕМЕННЫЕ
			this._border = _border;
			this._background = _background;
			// ДВИГАЕМ ЯЧЕЙКУ
			this.x = _positionX;
			this.y = _positionY;
			// РИСУЕМ ЯЧЕЙКУ
			this._cellDraw(false);
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		РИСУЕМ ЯЧЕЙКУ																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _cellDraw(_status:Boolean):void {
			// УДАЛЯЕМ СТАРУЮ ЯЧЕЙКУ
			if (this.getChildByName('CellShape')) {
				this.removeChild( this.getChildByName ( 'CellShape' ) );
			}
			// ЗАДАЕМ ПРОЗРАЧНОСТЬ НОВОЙ ЯЧЕЙКИ
			if (_status) {
				this._status = true;
				this._shape = new Square(0,0,Block._cellSize,_background,1,_border,1,1);
			}
			else {
				this._status = false;
				this._shape = new Square(0,0,Block._cellSize,_background,0,_border,1,1);
			}
			// РИСУЕМ НОВУЮ ЯЧЕЙКУ
			this._shape.name = 'CellShape';
			this.addChild(this._shape);
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ОПЕРАЦИИ С ЯЧЕЙКОЙ																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function _stateChange(_action:String):void {
			switch (_action) {
				case 'FILL' :
					this._cellDraw(true);
					Block._eventDispatcher.dispatchEvent(new Event('CELL_FILLED'));
					break;
				case 'EMPTY' :
					this._cellDraw(false);
					break;
				case 'REVERSE' :
					if (this._status) {
						this._stateChange('EMPTY');
					}
					else {
						this._stateChange('FILL');
					}
			}
		}
	}
}