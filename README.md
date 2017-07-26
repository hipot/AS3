# AS3
ActionScript3 наработки, для истории ;)

## DttPlayer.as
mp3 плеер на AcrionScript3 

![вот так плеер выглядел, дизайн тоже мой](https://scontent-frt3-2.xx.fbcdn.net/v/t1.0-9/13092083_502801389911206_80607380109027565_n.jpg?oh=086ebf846ebd10841f8ddef9ae88fb26&oe=5A067F95)

### возможности:
* предлоадер 
* обработка ошибочных событий 
* передача старт/пауза через js
* кнопка паузы в самом плеере

Простой интерфейс через html/js:
  
  ```javascript
// функции для управления плеером
// флеш-плеер вызывает эту функцию для отображения информации (напр. ошибок)
var playerID = '#dtt_player'; 
  
// отобразить рядом с caller (плеер)
function attachPlayer(caller) {
	//...
} 
	
function stopPlayerSound() {
	$(playerID).playSound("");
}
function playPlayerSound( sndUrl ) {
	stopPlayerSound();
	$(playerID).playSound( sndUrl ); // данный метод открыть для доступа "извне"
}  
// для onClick
function playerSoung( caller, sUrl ) {
	window.setTimeout(function(){
		playPlayerSound(sUrl);
	}, 400); //ie
} 
```
```html
<a href="javascript:void(0);" onclick="playerSoung(this, 'mp3/cosm.mp3');return false;">Play Sound 1</a>
<a href="javascript:void(0);" onclick="playerSoung(this, 'mp3/snd2.mp3');return false;">Play Sound 2</a>
```
### Инстансы при дизайне во флеше (на панели свойств), дать имена:
scroller_load_mc - горизонтальный загрузчик
scroller_play_mc - плавающая головка в загрузчике
pause_btn, play_btn - кнопки пауза/старт
time_txt - поле с временем 00:00

  
