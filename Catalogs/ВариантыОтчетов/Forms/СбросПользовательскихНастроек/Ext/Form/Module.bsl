﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если Не Параметры.Свойство("Варианты") Или ТипЗнч(Параметры.Варианты) <> Тип("Массив") Тогда
		ТекстОшибки = "Не указаны варианты отчетов.";
		Возврат;
	КонецЕсли;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ ПЕРВЫЕ 1
	            	  |	ИСТИНА КАК ЕстьПользовательскиеНастройки
	            	  |ИЗ
	            	  |	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	            	  |ГДЕ
	            	  |	Настройки.Вариант В(&МассивВариантов)";

	Запрос.УстановитьПараметр("МассивВариантов", Параметры.Варианты);

	Если Запрос.Выполнить().Пустой() Тогда
		ТекстОшибки = "Пользовательские настройки выбранных вариантов отчетов (%1 шт) не заданы или уже сброшены.";
		ТекстОшибки = СтрШаблон(ТекстОшибки, Формат(Параметры.Варианты.Количество(), "ЧН=0; ЧГ=0"));

		Возврат;
	КонецЕсли;

	ИзменяемыеВарианты.ЗагрузитьЗначения(Параметры.Варианты);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаСбросить(Команда)
	КоличествоВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВариантов = 0 Тогда
		ПоказатьПредупреждение(, "Не указаны варианты отчетов.");
		Возврат;
	КонецЕсли;

	СброситьНастройкиПользователейСервер(ИзменяемыеВарианты);
	Если КоличествоВариантов = 1 Тогда
		СсылкаВарианта		= ИзменяемыеВарианты[0].Значение;
		ОповещениеЗаголовок = "Сброшены пользовательские настройки варианта отчета";
		ОповещениеСсылка    = ПолучитьНавигационнуюСсылку(СсылкаВарианта);
		ОповещениеТекст     = Строка(СсылкаВарианта);
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
	Иначе
		ОповещениеТекст = "Сброшены пользовательские настройки
		|вариантов отчетов (%1 шт.).";
		ОповещениеТекст = СтрШаблон(ОповещениеТекст, Формат(КоличествоВариантов, "ЧН=0; ЧГ=0"));
		ПоказатьОповещениеПользователя(, , ОповещениеТекст);
	КонецЕсли;
	Закрыть();
КонецПроцедуры

#КонецОбласти

&НаСервереБезКонтекста
Процедура СброситьНастройкиПользователейСервер(Знач ИзменяемыеВарианты)
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСписка.Значение);
		КонецЦикла;
		Блокировка.Заблокировать();

		РегистрыСведений.НастройкиВариантовОтчетов.СброситьНастройки(ИзменяемыеВарианты.ВыгрузитьЗначения());

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры