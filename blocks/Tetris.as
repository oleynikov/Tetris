package blocks {
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	ИМПОРТ ПАКЕТОВ																													//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	import blocks.bricks.*;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КЛАСС - ТЕТРИС																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public class Tetris extends Block {



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		СВОЙСТВА КЛАССА																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private var _field:Field;
		private var _brick:Brick;
		private var _statusBar:StatusBar;
		private var _timer:Timer;
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КОНСТРУКТОР КЛАССА																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function Tetris():void {
			/*this._brick = new Brick_0();
			this._brick.x = 100;
			this._brick.y = 100;
			this.addChild(this._brick);*/
			
			
			
			
			
			
			// РИСУЕМ ИГРОВОЕ ПОЛЕ
			this._field = new Field();
			this.addChild(this._field);
			// ДОБАВЛЯЕМ СТРОКУ СОСТОЯНИЯ
			this._statusBar = new StatusBar();
			this._statusBar.y = Block._cellSize * Block._fieldHeight;
			this.addChild(this._statusBar);
			// БРОСАЕМ КИРПИЧ
			this._brickThrow(new Event(''));
			// СЛУШАЕМ КЛАВИАТУРУ
			stage.addEventListener(KeyboardEvent.KEY_DOWN,_keyPressed);
			
			
			
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		БРОСАЕМ КИРПИЧ																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _brickThrow (_event:Event):void {
			// КИРПИЧ ПРИЗЕМЛИЛСЯ
			if ( this.getChildByName('Brick') ) {
				// УДАЛЯЕМ СТАРЫЙ КИРПИЧ
				this.removeChild(this.getChildByName('Brick'));
				// ДЕЛАЕМ ОТПЕЧАТОК КИРПИЧА НА ИГРОВОМ ПОЛЕ
				for ( var i:String in this._brick._brickBlocks ) {
					// АБСЦИССА КВАДРАТИКА КИРПИЧИКА
					var squareBlockX:uint = this._brick.x / Block._cellSize + this._brick._brickBlocks[i][0];
					// ОРДИНАТА КВАДРАТИКА КИРПИЧИКА
					var squareBlockY:uint = this._brick.y / Block._cellSize + this._brick._brickBlocks[i][1];
					this._field._cells[squareBlockY][squareBlockX]._stateChange('FILL');
				}
				Block._eventDispatcher.dispatchEvent(new Event('BRICK_PRINTED'));
			}
			var _brickNumber = Math.round ( 4 * Math.random() );
			switch ( _brickNumber ) {
				case 0:
					this._brick = new Brick_0();
					break;
				case 1:
					this._brick = new Brick_1();
					break;
				case 2:
					this._brick = new Brick_2();
					break;
				case 3:
					this._brick = new Brick_3();
					break;
				case 4:
					this._brick = new Brick_4();
					break;					
			}
			this._brick.x = Block._cellSize * 3;
			this._brick.name = 'Brick';
			this.addChild(this._brick);
			Block._eventDispatcher.addEventListener('BRICK_FELL',_brickThrow);
			// ТАЙМЕР ГРАВИТАЦИИ
			this._timer = new Timer( ( 1000 - Block._speed * 100 ) , 0 );
			this._timer.start();
			this._timer.addEventListener(TimerEvent.TIMER,_gravityApply);
		}
		
		

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		НАЖАТА КНОПКА																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _keyPressed (_event:KeyboardEvent):void {
			var _squaresLeft:uint = new uint();
			var _key:String = new String();
			var _squareY:Number;
			var _squareX:Number;
						
			switch ( _event.keyCode ) {
				// СТРЕЛКА ВЛЕВО
				case 37:
					// ПРОВЕРКА НА ЗАПОЛНЕННЫЕ ЯЧЕЙКИ СЛЕВА ОТ КИРПИЧА
					for ( _key in this._brick._brickBlocks ) {
						_squareY = this._brick.y / Block._cellSize + this._brick._brickBlocks[_key][1];
						_squareX = this._brick.x / Block._cellSize + this._brick._brickBlocks[_key][0];
						if ( _squareY > 0 && _squareX > 0 ) {
							if ( this._field._cells[_squareY][_squareX-1]._status ) {
								_squaresLeft ++;
							}
						}
					}
					if ( _squaresLeft == 0 ) {
						this._brick._push('LEFT');
					}
					break;
				// СТРЕЛКА ВПРАВО
				case 39:
					// ПРОВЕРКА НА ЗАПОЛНЕННЫЕ ЯЧЕЙКИ СПРАВА ОТ КИРПИЧА
					for ( _key in this._brick._brickBlocks ) {
						_squareY = this._brick.y / Block._cellSize + this._brick._brickBlocks[_key][1];
						_squareX = this._brick.x / Block._cellSize + this._brick._brickBlocks[_key][0];
						if ( _squareY > 0 && _squareX < Block._fieldWidth - 1 ) {
							if ( this._field._cells[_squareY][_squareX+1]._status ) {
								_squaresLeft ++;
							}
						}
					}
					if ( _squaresLeft == 0 ) {
						this._brick._push('RIGHT');
					}
					break;
				// СТРЕЛКА ВНИЗ
				case 40:
					// ПРОВЕРКА НА ЗАПОЛНЕННЫЕ ЯЧЕЙКИ ПОД КИРПИЧОМ
					for ( _key in this._brick._brickBlocks ) {
						_squareY = this._brick.y / Block._cellSize + this._brick._brickBlocks[_key][1];
						_squareX = this._brick.x / Block._cellSize + this._brick._brickBlocks[_key][0];
						if ( _squareY > -2 && _squareY < Block._fieldHeight - 1 ) {
							if ( this._field._cells[_squareY+1][_squareX]._status ) {
								_squaresLeft ++;
							}
						}
					}
					if ( _squaresLeft == 0 ) {
						this._brick._push('BOTTOM');
					}
					break;
				// ПРОБЕЛ
				case 32:
					this._brick._rotate(this._field._cells);
					break;
			}
		}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ПРИМЕНЯЕМ ГРАВИТАЦИЮ																										//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _gravityApply (_event:TimerEvent):void {
			var _bricksOnTheGround:uint = new uint();
			for ( var _i:String in this._brick._blocksSprites ) {
				var _brickSquareY:Number = this._brick.y / Block._cellSize + this._brick._brickBlocks[_i][1];
				if ( _brickSquareY == Block._fieldHeight - 1 ) {
					_bricksOnTheGround ++;
				}
			}
			if ( _bricksOnTheGround == 0 ) {
				// ПРОВЕРЯЕМ ЯЧЕЙКИ ПОД КИРПИЧОМ
				var _cellsUnderBrick:Number = new uint();
				for ( var _j:String in this._brick._brickBlocks ) {
					// АБСЦИССА КВАДРАТИКА КИРПИЧИКА
					var squareBlockX:Number = this._brick.x / Block._cellSize + this._brick._brickBlocks[_j][0];
					// ОРДИНАТА КВАДРАТИКА КИРПИЧИКА
					var squareBlockY:Number = this._brick.y / Block._cellSize + this._brick._brickBlocks[_j][1];
					// ПРОВЕРЯЕМ ЯЧЕЙКУ ПОД КИРПИЧИКОМ
					if ( this._field._cells[squareBlockY+1][squareBlockX]._status ) {
						_cellsUnderBrick ++;
					}
				}
				if(_cellsUnderBrick == 0) {
					this._brick._push('BOTTOM');
				}
				else {
					this._timer.removeEventListener(TimerEvent.TIMER,_gravityApply);
					Block._eventDispatcher.dispatchEvent(new Event('BRICK_FELL'));
				}
			}
			else {
				this._timer.removeEventListener(TimerEvent.TIMER,_gravityApply);
				Block._eventDispatcher.dispatchEvent(new Event('BRICK_FELL'));
			}
		}
	}
}