﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастройкиПодсистемы = ОбновлениеИБСервер.НастройкиПодсистемы();
	ТекстПодсказки      = НастройкиПодсистемы.ПоясненияДляРезультатовОбновления;

	Если Не ПустаяСтрока(ТекстПодсказки) Тогда
		Элементы.Подсказка.Заголовок = ТекстПодсказки;
	КонецЕсли;

	НастройкиПодсистемы = ОбновлениеИБСервер.НастройкиПодсистемы();
	ПараметрыСообщения  = НастройкиПодсистемы.ПараметрыСообщенияОНевыполненныхОтложенныхОбработчиках;

	Если ЗначениеЗаполнено(ПараметрыСообщения.ТекстСообщения) Тогда
		Элементы.Сообщение.Заголовок = ПараметрыСообщения.ТекстСообщения;
	КонецЕсли;

	Если ПараметрыСообщения.КартинкаСообщения <> Неопределено Тогда
		Элементы.Картинка.Картинка = ПараметрыСообщения.КартинкаСообщения;
	КонецЕсли;

	Если ПараметрыСообщения.ЗапрещатьПродолжение Тогда
		Элементы.ФормаПродолжить.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Завершить(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьОбновление(Команда)
	Закрыть(Истина);
КонецПроцедуры

#КонецОбласти
