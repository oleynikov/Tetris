﻿package blocks {
	import engine.Label;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	ИМПОРТ ПАКЕТОВ																													//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//	КЛАСС - СТРОКА СОСТОЯНИЯ																										//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	public class StatusBar extends Block {



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		СВОЙСТВА КЛАССА																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private var _score:TextField;
		private var _speed:TextField;
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		КОНСТРУКТОР КЛАССА																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		public function StatusBar() {
			// ФОРМАТ НАДПИСЕЙ
			var _textFormat:TextFormat = new TextFormat('Tahoma',15,0xffffff);
			// СЧЕТ
			this._score = new TextField();
			this._score.defaultTextFormat = _textFormat;
			this._score.text = 'Счет: 0';
			this.addChild(this._score);
			// СКОРОСТЬ
			this._speed = new TextField();
			this._speed.defaultTextFormat = _textFormat;
			this._speed.x = Block._cellSize * Block._fieldWidth / 2;
			this._speed.text = 'Скорость: 0';
			this.addChild(this._speed);
			// СЛУШАЕМ ИЗМЕНЕНИЕ СЧЕТА
			Block._eventDispatcher.addEventListener('SCORE_CHANGED',_scoreChanged);
			// СЛУШАЕМ ИЗМЕНЕНИЕ СКОРОСТИ
			Block._eventDispatcher.addEventListener('SPEED_CHANGED',_speedChanged);
		}
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ОБНОВЛЯЕМ СЧЕТ																												//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _scoreChanged (_event:Event):void {
			this._score.text = 'Счет: ' + Block._score;
		}
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																																	//
//		ОБНОВЛЯЕМ СКОРОСТЬ																											//
//																																	//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		private function _speedChanged (_event:Event):void {
			this._speed.text = 'Скорость: ' + Block._speed;
		}
	}
}