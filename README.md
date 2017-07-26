# AS3
ActionScript3

## DttPlayer.as
mp3 плеер на AcrionScript3 

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
    
  
