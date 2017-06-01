﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыПродолжения;
&НаКлиенте
Перем РезультатВыполненияОбновления;
&НаКлиенте
Перем ОбработкаЗавершения;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ВыполняетсяОбновлениеВерсииИБ = Истина;
	ВремяНачалаОбновления = ТекущаяДатаСеанса();

	КлиентСервер  = Не БазоваяПодсистемаСервер.ИнформационнаяБазаФайловая();

	ПараметрыЗапускаПрограммы = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
	ПараметрыЗапускаМассивом = СтрРазделить(ПараметрыЗапускаПрограммы, ";");
	Для Каждого Параметр Из ПараметрыЗапускаМассивом Цикл
		Если СтрНайти(Параметр, "ЧислоПотоковОбновления") > 0 Тогда
			ПотокиОбновления = СтрРазделить(Параметр, "=");
			Попытка
				МаксимальноПотоков = Число(ПотокиОбновления[1]);
			Исключение
				ТекстИсключения = "Неправильно указан параметр запуска программы ""ЧислоПотоковОбновления"".
					|Правильный формат - ""ЧислоПотоковОбновления=Х"", где ""Х"" - максимальное количество потоков обновления.";
				ВызватьИсключение ТекстИсключения;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;

	Если МаксимальноПотоков = 0 Тогда
		МаксимальноПотоков = 8;
	КонецЕсли;

	ПрогрессВыполнения = 5;

	РежимОбновленияДанных = ОбновлениеИБСервер.РежимОбновленияДанных();

	ТолькоОбновлениеПараметровРаботыПрограммы = Не ОбновлениеИБСерверПовтИсп.НеобходимоОбновлениеИнформационнойБазы();

	Если ТолькоОбновлениеПараметровРаботыПрограммы Тогда
		Заголовок								= "Обновление параметров работы программы";
		Элементы.РежимЗапуска.ТекущаяСтраница	= Элементы.ОбновлениеПараметровРаботыПрограммы;
	ИначеЕсли РежимОбновленияДанных = "НачальноеЗаполнение" Тогда
		Заголовок								= "Начальное заполнение данных";
		Элементы.РежимЗапуска.ТекущаяСтраница	= Элементы.НачальноеЗаполнение;
	ИначеЕсли РежимОбновленияДанных = "ПереходСДругойПрограммы" Тогда
		Заголовок								= "Переход с другой программы";
		Элементы.РежимЗапуска.ТекущаяСтраница	= Элементы.ПереходСДругойПрограммы;
		Элементы.ТекстСообщенияПереходСДругойПрограммы.Заголовок = СтрШаблон(Элементы.ТекстСообщенияПереходСДругойПрограммы.Заголовок, Метаданные.Синоним);
	Иначе
		Заголовок								= "Обновление версии программы";
		Элементы.РежимЗапуска.ТекущаяСтраница	= Элементы.ОбновлениеВерсииПрограммы;
		Элементы.ТекстСообщенияОбновляемаяКонфигурация.Заголовок = СтрШаблон(Элементы.ТекстСообщенияОбновляемаяКонфигурация.Заголовок, Метаданные.Синоним, Метаданные.Версия);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если ЗавершениеРаботы Тогда
		Если ВыполняетсяОбновлениеВерсииИБ Тогда
			Отказ = Истина;
		КонецЕсли;

		Возврат;
	КонецЕсли;

	Если ВыполняетсяОбновлениеВерсииИБ Тогда
		Отказ = Истина;
	ИначеЕсли МонопольныйРежимУстановлен Тогда
		СнятьМонопольныйРежим();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТехническаяИнформацияНажатие(Элемент)
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ЗапускатьНеВФоне", Истина);
	ПараметрыОтбора.Вставить("ДатаНачала", ВремяНачалаОбновления);

	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ПараметрыОтбора, Неопределено);
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура НачатьЗакрытие() Экспорт
	ПодключитьОбработчикОжидания("ПродолжитьЗакрытие", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗакрытие() Экспорт
	ВыполняетсяОбновлениеВерсииИБ = Ложь;

	ЗакрытьФорму(Ложь, Ложь);
КонецПроцедуры


&НаСервереБезКонтекста
Процедура СнятьМонопольныйРежим()
	Если МонопольныйРежим() Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;

	МонопольныйРежимУстановлен = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры) Экспорт
	ПараметрыПродолжения = Параметры;
	ПодключитьОбработчикОжидания("НачатьОбновлениеПараметровРаботыПрограммы", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеПараметровРаботыПрограммы()
	РезультатВыполнения = ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне();

	ДополнительныеПараметры = Новый Структура("КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки");

	Если РезультатВыполнения = "ЗапускНеТребуется" Тогда
		Результат = Новый Структура("Статус", "ЗапускНеТребуется");
		ЗавершитьОбновлениеПараметровРаботыПрограммы(Результат, ДополнительныеПараметры);

		Возврат;
	КонецЕсли;

	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьОбновлениеПараметровРаботыПрограммы",ЭтотОбъект, ДополнительныеПараметры);

	ПараметрыОжидания									= БазоваяПодсистемаКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания				= Ложь;
	ПараметрыОжидания.Интервал							= 2;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения		= Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения	= Новый ОписаниеОповещения("ПрогрессОбновленияПараметровРаботыПрограммы", ЭтотОбъект);
	БазоваяПодсистемаКлиент.ОжидатьЗавершение(РезультатВыполнения, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

&НаСервере
Функция ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне()
	ОбновитьПовторноИспользуемыеЗначения();

	// Вызов длительной операции (обычно в фоновом задании).
	Возврат РегистрыСведений.ПараметрыРаботыПрограммы.ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне(0,УникальныйИдентификатор, Истина);
КонецФункции

&НаКлиенте
Процедура ПрогрессОбновленияПараметровРаботыПрограммы(Прогресс, ДополнительныеПараметры) Экспорт
	Если Прогресс = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Прогресс.Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;

	Если Прогресс.Прогресс <> Неопределено Тогда
		Если ТолькоОбновлениеПараметровРаботыПрограммы Тогда
			ПрогрессВыполнения = 5 + (90 * Прогресс.Прогресс.Процент / 100);
		Иначе
			ПрогрессВыполнения = 5 + (5 * Прогресс.Прогресс.Процент / 100);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьОбновлениеПараметровРаботыПрограммы(Результат, ДополнительныеПараметры) Экспорт
	Попытка
		ОбработанныйРезультат	= ОбработанныйРезультатДлительнойОперации(Результат);
	Исключение
		ИнформацияОбОшибке		= ИнформацияОбОшибке();
		ОбработанныйРезультат	= Новый Структура;
		ОбработанныйРезультат.Вставить("КраткоеПредставлениеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		ОбработанныйРезультат.Вставить("ПодробноеПредставлениеОшибки", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
	КонецПопытки;

	Если ЗначениеЗаполнено(ОбработанныйРезультат.КраткоеПредставлениеОшибки) Тогда
		СообщениеОНеудачномОбновлении(ОбработанныйРезультат, Неопределено);

		Возврат;
	КонецЕсли;

	ПрогрессВыполнения = ?(ТолькоОбновлениеПараметровРаботыПрограммы, 95, 10);

	ПараметрыПродолжения.ПолученныеПараметрыКлиента.Вставить("НеобходимоОбновлениеПараметровРаботыПрограммы");
	ПараметрыПродолжения.Вставить("КоличествоПолученныхПараметровКлиента",ПараметрыПродолжения.ПолученныеПараметрыКлиента.Количество());

	ОбновитьПовторноИспользуемыеЗначения();

	Попытка
		ПараметрыКлиента = БазоваяПодсистемаКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ДополнительныеПараметры.Вставить("КраткоеПредставлениеОшибки", КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		ДополнительныеПараметры.Вставить("ПодробноеПредставлениеОшибки", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		СообщениеОНеудачномОбновлении(ДополнительныеПараметры, Неопределено);

		Возврат;
	КонецПопытки;

	Если Не ТолькоОбновлениеПараметровРаботыПрограммы Тогда
		ВыполнитьОбработкуОповещения(ПараметрыПродолжения.ОбработкаПродолжения);

		Возврат;
	КонецЕсли;

	Если БлокировкаИБ <> Неопределено
		И БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы") Тогда
		ОбновлениеИБВызовСервера.СнятьБлокировкуФайловойБазы();
	КонецЕсли;

	ЗакрытьФорму(Ложь, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьФорму(Отказ, Перезапустить)
	ВыполняетсяОбновлениеВерсииИБ = Ложь;
	Закрыть(Новый Структура("Отказ, Перезапустить", Отказ, Перезапустить));
КонецПроцедуры

&НаКлиенте
Процедура СообщениеОНеудачномОбновлении(ДополнительныеПараметры, ВремяОкончанияОбновления)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьИнформационнуюБазуДействияПриОшибке", ЭтотОбъект);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КраткоеПредставлениеОшибки",   ДополнительныеПараметры.КраткоеПредставлениеОшибки);
	ПараметрыФормы.Вставить("ПодробноеПредставлениеОшибки", ДополнительныеПараметры.ПодробноеПредставлениеОшибки);
	ПараметрыФормы.Вставить("ВремяНачалаОбновления",      ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ВремяОкончанияОбновления",   ВремяОкончанияОбновления);

	Если ЗначениеЗаполнено(ИмяПланаОбмена) Тогда
		// зарезервировано для новых подсистем
		ПараметрыФормы.Вставить("ИмяПланаОбмена", ИмяПланаОбмена);
	Иначе
		ИмяОткрываемойФормы = "Обработка.РезультатыОбновленияПрограммы.Форма.СообщениеОНеудачномОбновлении";
	КонецЕсли;

	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы,,,,,ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазу() Экспорт
	ПрогрессВыполнения = 10;
	ПодключитьОбработчикОжидания("НачатьОбновлениеИнформационнойБазы", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеИнформационнойБазы()
	ВремяНачалаОбновления = БазоваяПодсистемаКлиент.ДатаСеанса();

	РезультатОбновленияИБ = ОбновитьИнформационнуюБазуВФоне();

	Если Не РезультатОбновленияИБ.Свойство("АдресРезультата") Тогда
		ЗавершитьОбновлениеИнформационнойБазы(РезультатОбновленияИБ, Неопределено);

		Возврат;
	КонецЕсли;

	Если КлиентСервер Тогда
		ПроцедураПродолжения = "ЗарегистрироватьДанныеДляОтложенногоОбновления";
	Иначе
		ПроцедураПродолжения = "ЗавершитьОбновлениеИнформационнойБазы";
	КонецЕсли;

	ОповещениеОЗавершении								= Новый ОписаниеОповещения(ПроцедураПродолжения, ЭтотОбъект);
	ПараметрыОжидания									= БазоваяПодсистемаКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания				= Ложь;
	ПараметрыОжидания.ВыводитьПрогрессВыполнения		= Истина;
	ПараметрыОжидания.ВыводитьСообщения					= Истина;
	ПараметрыОжидания.ОповещениеОПрогрессеВыполнения	= Новый ОписаниеОповещения("ПрогрессОбновленияИнформационнойБазы", ЭтотОбъект);
	БазоваяПодсистемаКлиент.ОжидатьЗавершение(РезультатОбновленияИБ, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

&НаСервере
Функция ОбновитьИнформационнуюБазуВФоне()
	Результат		= ОбновлениеИБСервер.ОбновитьИнформационнуюБазуВФоне(УникальныйИдентификатор, БлокировкаИБ);
	БлокировкаИБ	= Результат.БлокировкаИБ;

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ЗавершитьОбновлениеИнформационнойБазы(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Или Результат.Статус = "Отменено" Тогда
		ПризнакВыполненияОбработчиков = БлокировкаИБ.Ошибка;
	ИначеЕсли Результат.Статус = "Выполнено"  Тогда
		РезультатОбновления = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ТипЗнч(РезультатОбновления) = Тип("Структура") Тогда
			Если РезультатОбновления.Свойство("КраткоеПредставлениеОшибки") И РезультатОбновления.Свойство("ПодробноеПредставлениеОшибки") Тогда
				Результат.КраткоеПредставлениеОшибки	= РезультатОбновления.КраткоеПредставлениеОшибки;
				Результат.ПодробноеПредставлениеОшибки	= РезультатОбновления.ПодробноеПредставлениеОшибки;
			Иначе
				ПризнакВыполненияОбработчиков			= РезультатОбновления.Результат;
				УстановитьПараметрыСеансаИзФоновогоЗадания(РезультатОбновления.ПараметрыКлиентаНаСервере);
				ПрогрессВыполнения						= 100;
			КонецЕсли;
		Иначе
			ПризнакВыполненияОбработчиков = РезультатОбновления;
		КонецЕсли;
		ОбработатьОшибкуПравилРегистрации(Результат.Сообщения);
	Иначе // ошибка
		ПризнакВыполненияОбработчиков = БлокировкаИБ.Ошибка;
	КонецЕсли;

	Если ПризнакВыполненияОбработчиков = "ЗаблокироватьВыполнениеРегламентныхЗаданий" Тогда
		НовыйПараметрЗапуска = ПараметрЗапуска + ";РегламентныеЗаданияОтключены";
		НовыйПараметрЗапуска = "/AllowExecuteScheduledJobs -Off " + "/C """ + НовыйПараметрЗапуска + """";
		ПрекратитьРаботуСистемы(Истина, НовыйПараметрЗапуска);
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДокументОписаниеОбновлений",		Неопределено);
	ДополнительныеПараметры.Вставить("КраткоеПредставлениеОшибки",		Результат.КраткоеПредставлениеОшибки);
	ДополнительныеПараметры.Вставить("ПодробноеПредставлениеОшибки",	Результат.ПодробноеПредставлениеОшибки);
	ДополнительныеПараметры.Вставить("ВремяНачалаОбновления",			ВремяНачалаОбновления);
	ДополнительныеПараметры.Вставить("ВремяОкончанияОбновления",		БазоваяПодсистемаКлиент.ДатаСеанса());
	ДополнительныеПараметры.Вставить("ПризнакВыполненияОбработчиков",	ПризнакВыполненияОбработчиков);

	Если ПризнакВыполненияОбработчиков = "ОшибкаУстановкиМонопольногоРежима" Тогда
		ОбновитьИнформационнуюБазуПриОшибкеУстановкиМонопольногоРежима(ДополнительныеПараметры);

		Возврат;
	КонецЕсли;

	СнятьБлокировкуФайловойБазы = Ложь;
	Если БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы", СнятьБлокировкуФайловойБазы) Тогда
		Если СнятьБлокировкуФайловойБазы Тогда
			ОбновлениеИБВызовСервера.СнятьБлокировкуФайловойБазы();
		КонецЕсли;
	КонецЕсли;

	ОбновитьИнформационнуюБазуЗавершение(ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуПриОшибкеУстановкиМонопольногоРежима(ДополнительныеПараметры)
	Если ДополнительныеПараметры.ПризнакВыполненияОбработчиков <> "ОшибкаУстановкиМонопольногоРежима" Тогда
		ОбновитьИнформационнуюБазуЗавершение(ДополнительныеПараметры);

		Возврат;
	КонецЕсли;

	СообщениеОНеудачномОбновлении(ДополнительныеПараметры, Неопределено);

	Возврат;

	// Зарезервировано для новых подсистем
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуЗавершение(ДополнительныеПараметры)
	Если ЗначениеЗаполнено(ДополнительныеПараметры.КраткоеПредставлениеОшибки) Тогда
		ВремяОкончанияОбновления = БазоваяПодсистемаКлиент.ДатаСеанса();

		СообщениеОНеудачномОбновлении(ДополнительныеПараметры, ВремяОкончанияОбновления);

		Возврат;
	КонецЕсли;

	ОбновитьИнформационнуюБазуЗавершениеСервер(ДополнительныеПараметры);
	ОбновитьПовторноИспользуемыеЗначения();

	ЗакрытьФорму(Ложь, Ложь);
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформационнуюБазуЗавершениеСервер(ДополнительныеПараметры)
	// Если обновление ИБ завершилось - разблокируем ИБ.
	ОбновлениеИБСервер.РазблокироватьИБ(БлокировкаИБ);
	ОбновлениеИБСервер.ЗаписатьВремяВыполненияОбновления(ДополнительныеПараметры.ВремяНачалаОбновления, ДополнительныеПараметры.ВремяОкончанияОбновления);
КонецПроцедуры


&НаСервереБезКонтекста
Процедура УстановитьПараметрыСеансаИзФоновогоЗадания(ПараметрыКлиентаНаСервере)
	ПараметрыСеанса.ПараметрыКлиентаНаСервере = ПараметрыКлиентаНаСервере;
КонецПроцедуры

&НаКлиенте
Процедура ЗарегистрироватьДанныеДляОтложенногоОбновления(Результат, ДополнительныеПараметры) Экспорт
	РезультатОбновления = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);

	ОбработкаЗавершения = Новый ОписаниеОповещения("ЗавершитьОбновлениеИнформационнойБазы", ЭтотОбъект, Результат);
	РезультатВыполненияОбновления = Результат;
	Если Результат.Статус <> "Выполнено"
		Или (ТипЗнч(РезультатОбновления) = Тип("Структура")
			И РезультатОбновления.Свойство("КраткоеПредставлениеОшибки")
			И РезультатОбновления.Свойство("ПодробноеПредставлениеОшибки")) Тогда
		ВыполнитьОбработкуОповещения(ОбработкаЗавершения, РезультатВыполненияОбновления);
		Возврат;
	КонецЕсли;

	СостояниеРегистрации = ЗаполнениеДанныхДляПараллельногоОтложенногоОбновления();
	Если СостояниеРегистрации.Статус <> "Выполняется" Тогда
		ЗаполнитьЗначенияСвойств(РезультатВыполненияОбновления, СостояниеРегистрации);
		ВыполнитьОбработкуОповещения(ОбработкаЗавершения, РезультатВыполненияОбновления);
	Иначе
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданий", 5);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗаполнениеДанныхДляПараллельногоОтложенногоОбновления()
	// Очистка плана обмена ОбновлениеИнформационнойБазы.
	Если Не (БазоваяПодсистемаСерверПовтИсп.ИспользуетсяРИБ("СФильтром") И БазоваяПодсистемаСервер.ЭтоПодчиненныйУзелРИБ()) Тогда
		Запрос			= Новый Запрос;
		Запрос.Текст	= "ВЫБРАТЬ
		            	  |	ОбновлениеИнформационнойБазы.Ссылка КАК Узел
		            	  |ИЗ
		            	  |	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
		            	  |ГДЕ
		            	  |	НЕ ОбновлениеИнформационнойБазы.ЭтотУзел";

		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ПланыОбмена.УдалитьРегистрациюИзменений(Выборка.Узел);
		КонецЦикла;
	КонецЕсли;

	СведенияОбОбновлении = ОбновлениеИБСервер.СведенияОбОбновленииИнформационнойБазы();
	ОписанияБиблиотек    = БазоваяПодсистемаСерверПовтИсп.ОписанияПодсистем().ПоИменам;

	ОписаниеПроцедур = Новый Соответствие;

	Для Каждого ОписаниеБиблиотеки Из СведенияОбОбновлении.ДеревоОбработчиков.Строки Цикл
		Если ОписанияБиблиотек[ОписаниеБиблиотеки.ИмяБиблиотеки].РежимВыполненияОтложенныхОбработчиков <> "Параллельно" Тогда
			ОбновлениеИБСервер.ОтметитьРегистрациюОтложенныхОбработчиковОбновления(ОписаниеБиблиотеки.ИмяБиблиотеки, Истина);

			Продолжить;
		КонецЕсли;

		ПараллельноСВерсии			= ОписанияБиблиотек[ОписаниеБиблиотеки.ИмяБиблиотеки].ПараллельноеОтложенноеОбновлениеСВерсии;
		ЕстьДанныеДляРегистрации	= Ложь;

		Для Каждого ОписаниеВерсии Из ОписаниеБиблиотеки.Строки Цикл
			Если ОписаниеВерсии.НомерВерсии = "*" Тогда
				Продолжить;
			КонецЕсли;

			Если ЗначениеЗаполнено(ПараллельноСВерсии)
				И БазоваяПодсистемаКлиентСервер.СравнитьВерсии(ОписаниеВерсии.НомерВерсии, ПараллельноСВерсии) < 0 Тогда
				Продолжить;
			КонецЕсли;

			ЕстьДанныеДляРегистрации = Истина;
			Для Каждого ОписаниеОбработчика Из ОписаниеВерсии.Строки Цикл
				Очередь             = ОписаниеОбработчика.ОчередьОтложеннойОбработки;
				ПроцедураЗаполнения = ОписаниеОбработчика.ПроцедураЗаполненияДанныхОбновления;
				ИмяОбработчика      = ОписаниеОбработчика.ИмяОбработчика;

				ОписаниеПроцедуры = Новый Структура;
				ОписаниеПроцедуры.Вставить("Статус", "");
				ОписаниеПроцедуры.Вставить("Очередь", Очередь);
				ОписаниеПроцедуры.Вставить("ПроцедураЗаполнения", ПроцедураЗаполнения);
				ОписаниеПроцедуры.Вставить("ИмяОбработчика", ИмяОбработчика);

				ОписаниеПроцедур.Вставить(ИмяОбработчика, ОписаниеПроцедуры);
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

	СведенияОбОбновлении.ОписаниеПроцедурЗаполнения = ОписаниеПроцедур;
	ОбновлениеИБСервер.ЗаписатьСведенияОбОбновленииИнформационнойБазы(СведенияОбОбновлении);

	// Зарезервировано для новых подсистем

	ХодРегистрации = Новый Структура;
	ХодРегистрации.Вставить("НачальныйПрогресс",	ПрогрессВыполнения);
	ХодРегистрации.Вставить("ВсегоПроцедур",		ОписаниеПроцедур.Количество());
	ХодРегистрации.Вставить("ВыполненоПроцедур",	0);

	ОписаниеПотоков = Новый СписокЗначений;

	// Снятие блокировки информационной базы и выполнение регистрации на плане обмена.
	ОбновлениеИБСервер.РазблокироватьИБ(БлокировкаИБ);

	Возврат ПроверкаЗапускФоновыхЗаданий();
КонецФункции

&НаСервере
Функция ПроверкаЗапускФоновыхЗаданий()
	РезультатПроверки = Новый Структура;
	РезультатПроверки.Вставить("Статус", "");
	РезультатПроверки.Вставить("КраткоеПредставлениеОшибки", "");
	РезультатПроверки.Вставить("ПодробноеПредставлениеОшибки", "");

	ЕстьАктивныеПотоки = Ложь;
	Если ОписаниеПотоков.Количество() = 0 Тогда // первый запуск
		// Корректировка количества потоков
		СведенияОбОбновлении			= ОбновлениеИБСервер.СведенияОбОбновленииИнформационнойБазы();
		КоличествоПроцедурЗаполнения	= СведенияОбОбновлении.ОписаниеПроцедурЗаполнения.Количество();
		Если КоличествоПроцедурЗаполнения < МаксимальноПотоков Тогда
			МаксимальноПотоков	= КоличествоПроцедурЗаполнения;
		КонецЕсли;

		Для ТекущийПоток = 1 По МаксимальноПотоков Цикл
			Результат = ЗапускЗадания();

			ЗаполнитьЗначенияСвойств(РезультатПроверки, Результат);
			Если Результат.Статус = "Ошибка" Тогда
				ОтменитьЗаданияПриОшибке();

				Возврат РезультатПроверки;
			ИначеЕсли Результат.Статус = "Выполняется" Тогда
				ЕстьАктивныеПотоки = Истина;
			КонецЕсли;

			ОписаниеПотока = Новый Структура;
			ОписаниеПотока.Вставить("ИдентификаторЗадания", Результат.ИдентификаторЗадания);
			ОписаниеПотока.Вставить("Статус", Результат.Статус);
			ОписаниеПотоков.Добавить(ОписаниеПотока);
		КонецЦикла;

		Если ЕстьАктивныеПотоки Тогда
			РезультатПроверки.Статус = "Выполняется";
		Иначе
			РезультатПроверки.Статус = "Выполнено";
			ОбновлениеИБСервер.ОтметитьРегистрациюОтложенныхОбработчиковОбновления();
		КонецЕсли;

		Возврат РезультатПроверки;
	КонецЕсли;

	ЗаполнениеДанныхЗавершено = Истина;
	Для Каждого ЭлементОписаниеПотока Из ОписаниеПотоков Цикл
		ОписаниеПотока = ЭлементОписаниеПотока.Значение;
		Если ОписаниеПотока.Статус = "Выполнено" Тогда
			Продолжить;
		КонецЕсли;

		ЗаполнениеДанныхЗавершено	= Ложь;
		Результат					= ПроверкаЗадания(ОписаниеПотока);

		Если Результат.Статус = "Ошибка" Тогда
			ОтменитьЗаданияПриОшибке();
			ЗаполнитьЗначенияСвойств(РезультатПроверки, Результат);

			Возврат РезультатПроверки;
		КонецЕсли;
	КонецЦикла;

	Если ЗаполнениеДанныхЗавершено Тогда
		РезультатПроверки.Статус = "Выполнено";
		ОбновлениеИБСервер.ОтметитьРегистрациюОтложенныхОбработчиковОбновления();
	Иначе
		РезультатПроверки.Статус = "Выполняется";
	КонецЕсли;

	// Обновление прогресса.
	СведенияОбОбновлении	= ОбновлениеИБСервер.СведенияОбОбновленииИнформационнойБазы();
	ВыполненоПроцедур		= 0;
	Для Каждого ЭлементОписаниеПроцедуры Из СведенияОбОбновлении.ОписаниеПроцедурЗаполнения Цикл
		ОписаниеПроцедуры = ЭлементОписаниеПроцедуры.Значение;
		Если ОписаниеПроцедуры.Статус = "Выполнено" Тогда
			ВыполненоПроцедур = ВыполненоПроцедур + 1;
		КонецЕсли;
	КонецЦикла;
	ХодРегистрации.ВыполненоПроцедур = ВыполненоПроцедур;
	Если ХодРегистрации.ВсегоПроцедур <> 0 Тогда
		ПрибавкаПрогресса	= ХодРегистрации.ВыполненоПроцедур / ХодРегистрации.ВсегоПроцедур * (100 - ХодРегистрации.НачальныйПрогресс);
	Иначе
		ПрибавкаПрогресса	= 0;
	КонецЕсли;
	ПрогрессВыполнения = ПрогрессВыполнения + ПрибавкаПрогресса;

	Возврат РезультатПроверки;
КонецФункции

&НаСервере
Процедура ОтменитьЗаданияПриОшибке()
	Если ОписаниеПотоков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Для Каждого ЭлементОписаниеПотока Из ОписаниеПотоков Цикл
		ОписаниеПотока = ЭлементОписаниеПотока.Значение;
		Если ОписаниеПотока.Статус = "Выполнено" Тогда
			Продолжить;
		КонецЕсли;

		БазоваяПодсистемаСервер.ОтменитьВыполнениеЗадания(ОписаниеПотока.ИдентификаторЗадания);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ПроверкаЗадания(ОписаниеПотока)
	Результат = БазоваяПодсистемаСервер.ОперацияВыполнена(ОписаниеПотока.ИдентификаторЗадания);

	Если Результат.Статус = "Выполнено" Тогда
		ОписаниеПотока.Статус = "Выполнено";
	КонецЕсли;

	Возврат Результат;
КонецФункции

&НаСервере
Функция ЗапускЗадания()
	ПараметрыВыполнения								= БазоваяПодсистемаСервер.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = "Фоновая регистрация данных отложенного обновления";
	ПараметрыВыполнения.ОжидатьЗавершение			= 0;

	Результат = БазоваяПодсистемаСервер.ВыполнитьВФоне("ОбновлениеИБСервер.ЗапускРегистрацииДанныхОтложенногоОбновления",Неопределено, ПараметрыВыполнения);

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданий()
	Результат = ПроверкаЗапускФоновыхЗаданий();

	Если Результат.Статус <> "Выполняется" Тогда
		ЗаполнитьЗначенияСвойств(РезультатВыполненияОбновления, Результат);
		ВыполнитьОбработкуОповещения(ОбработкаЗавершения, РезультатВыполненияОбновления);
		ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗаданий");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрогрессОбновленияИнформационнойБазы(Прогресс, ДополнительныеПараметры) Экспорт
	Если Прогресс = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Прогресс.Статус = "Ошибка" Тогда
		Возврат;
	КонецЕсли;

	Если Прогресс.Прогресс <> Неопределено Тогда
		ПрогрессВыполнения = 10 + (90 * Прогресс.Прогресс.Процент / 100);
	КонецЕсли;
	ОбработатьОшибкуПравилРегистрации(Прогресс.Сообщения);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформационнуюБазуДействияПриОшибке(ЗавершитьРаботу, ДополнительныеПараметры) Экспорт
	Если БлокировкаИБ <> Неопределено И БлокировкаИБ.Свойство("СнятьБлокировкуФайловойБазы") Тогда
		ОбновлениеИБВызовСервера.СнятьБлокировкуФайловойБазы();
	КонецЕсли;

	Если ЗавершитьРаботу <> Ложь Тогда
		ЗакрытьФорму(Истина, Ложь);
	Иначе
		ЗакрытьФорму(Истина, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбработанныйРезультатДлительнойОперации(Результат)
	Возврат РегистрыСведений.ПараметрыРаботыПрограммы.ОбработанныйРезультатДлительнойОперации(Результат);
КонецФункции

&НаКлиенте
Процедура ОбработатьОшибкуПравилРегистрации(СообщенияПользователю)
	Для Каждого СообщениеПользователю Из СообщенияПользователю Цикл
		НачалоСтроки = "ОбменДанными=";
		Если СтрНачинаетсяС(СообщениеПользователю.Текст, НачалоСтроки) Тогда
			ИмяПланаОбмена = Сред(СообщениеПользователю.Текст, СтрДлина(НачалоСтроки) + 1);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры