﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Очищает настройки по варианту отчета.
Процедура СброситьНастройки(ВариантСсылка = Неопределено) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	Если ВариантСсылка <> Неопределено Тогда
		НаборЗаписей.Отбор.Вариант.Установить(ВариантСсылка, Истина);
	КонецЕсли;
	НаборЗаписей.Записать(Истина);
КонецПроцедуры

#КонецЕсли