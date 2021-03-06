﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	// Следующие константы взаимоисключающие, используются в отдельных функциональных опциях.
	//
	// Константа.РаботаВАвтономномРежиме					-> ФО.РаботаВАвтономномРежиме
	// Константа.РаботаВЛокальномРежиме						-> ФО.РаботаВЛокальномРежиме

	Если Константы.ЭтоАвтономноеРабочееМесто.Получить() Тогда
		Значение	= Ложь;
	Иначе
		Значение	= Истина;
	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли