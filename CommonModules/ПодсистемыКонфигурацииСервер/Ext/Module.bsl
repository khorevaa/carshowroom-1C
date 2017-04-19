﻿// Определяет список модулей библиотек и конфигурации, которые предоставляют
// основные сведения о себе: имя, версия, список обработчиков обновления
// а также зависимости от других библиотек.
//
// Параметры:
//  МодулиПодсистем - Массив - имена серверных общих модулей библиотек и конфигурации.
//
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	МодулиПодсистем.Добавить("ПодсистемыКонфигурацииСервер");
КонецПроцедуры

Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	Описание.Имя										= "УправлениеАвтоцентром";
	Описание.Версия										= "1.0.0.1";
	Описание.РежимВыполненияОтложенныхОбработчиков		= "Параллельно";
	Описание.ПараллельноеОтложенноеОбновлениеСВерсии	= "1.0.0.1";

	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
КонецПроцедуры

// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных,
//                                          в которой изменилось имя основной конфигурации.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных) Экспорт

КонецПроцедуры

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

КонецПроцедуры

Процедура ПередОбновлениемИнформационнойБазы() Экспорт

КонецПроцедуры

Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия, Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт

КонецПроцедуры

Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт

КонецПроцедуры