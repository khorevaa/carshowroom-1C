﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем НовыйОбъект;

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	НовыйОбъект = ЭтоНовый();
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НовыйОбъект Тогда
		Справочники.ВерсииРасширений.ВключитьЗаданиеУдалениеУстаревшихПараметровРаботыВерсийРасширений(Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
