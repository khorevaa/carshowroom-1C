﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи"
//
////////////////////////////////////////////////////////////////////////////////

Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	ПараметрыКлиента = БазоваяПодсистемаКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();

	Если ПараметрыКлиента.Свойство("ОшибкаНедостаточноПравДляВходаВПрограмму") Тогда
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОшибкаНедостаточноПравДляВходаВПрограмму");
		УстановитьИнтерактивнуюОбработкуПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры, ПараметрыКлиента.ОшибкаНедостаточноПравДляВходаВПрограмму);
	КонецЕсли;
КонецПроцедуры

Процедура ПослеНачалаРаботыСистемы() Экспорт
	ПараметрыРаботыКлиента	= БазоваяПодсистемаКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Ключ					= БазоваяПодсистемаКлиентСервер.СвойствоСтруктуры(ПараметрыРаботыКлиента, "КлючПредупрежденияБезопасности");
	Если ЗначениеЗаполнено(Ключ) Тогда
		// Небольшая задержка чтобы платформа успела отрисовать текущее окно, поверх которого выводится окно предупреждения.
		ПодключитьОбработчикОжидания("ПоказатьПредупреждениеБезопасностиПослеЗапуска", 0.3, Истина);
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьИнтерактивнуюОбработкуПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры, ОписаниеОшибки) Экспорт
	Параметры.Отказ = Истина;
	Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограмму", ЭтотОбъект, ОписаниеОшибки);
КонецПроцедуры

// Предупреждает пользователя об ошибке недостатка прав для входа в программу.
Процедура ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры, ОписаниеОшибки) Экспорт
	ПоказатьПредупреждение(Новый ОписаниеОповещения("ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограммуПослеПредупреждения", ЭтотОбъект, Параметры),ОписаниеОшибки);
КонецПроцедуры

// Завершает работу после предупреждения пользователя об ошибке недостатка прав для входа в программу.
Процедура ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограммуПослеПредупреждения(Параметры) Экспорт
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
КонецПроцедуры

Процедура ПриВыполненииСтандартныхПериодическихПроверок(Параметры, ОбработкаПродолжения) Экспорт
	// Проверяет, что срок действия учетной записи истек и нужно завершить работу.
	Если Не Параметры.ВходВПрограммуЗапрещен Тогда
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения);

		Возврат;
	КонецЕсли;

	ОткрытьФорму("ОбщаяФорма.ВходВПрограммуЗапрещен");
КонецПроцедуры

// Открывает окно предупреждения безопасности.
Процедура ПоказатьПредупреждениеБезопасности() Экспорт
	ПараметрыРаботыКлиента	= БазоваяПодсистемаКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Ключ					= БазоваяПодсистемаКлиентСервер.СвойствоСтруктуры(ПараметрыРаботыКлиента, "КлючПредупрежденияБезопасности");
	Если ЗначениеЗаполнено(Ключ) Тогда
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", Новый Структура("Ключ", Ключ));
	КонецЕсли;
КонецПроцедуры

