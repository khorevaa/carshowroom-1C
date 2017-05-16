﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Контекст = Новый Структура;
	Контекст.Вставить("ТекущийПользователь", ПользователиКлиентСервер.АвторизованныйПользователь());
	Контекст.Вставить("ПолныеПраваНаВарианты", РольДоступна(Метаданные.Роли.ПолныеПрава));

	ПрототипКлюч = Параметры.КлючТекущихНастроек;

	ОтчетИнформация = ВариантыОтчетовСервер.СформироватьИнформациюОбОтчетеПоПолномуИмени(Параметры.КлючОбъекта);
	Если ТипЗнч(ОтчетИнформация.ТекстОшибки) = Тип("Строка") Тогда
		ВызватьИсключение ОтчетИнформация.ТекстОшибки;
	КонецЕсли;
	Контекст.Вставить("ОтчетСсылка", ОтчетИнформация.Отчет);
	Контекст.Вставить("ОтчетИмя",    ОтчетИнформация.ОтчетИмя);
	Контекст.Вставить("ТипОтчета",   ОтчетИнформация.ТипОтчета);
	Контекст.Вставить("ЭтоВнешний",  ОтчетИнформация.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Контекст.Вставить("ПоискПоНаименованию", Новый Соответствие);

	ЗаполнитьСписокВариантов(Ложь);

	Если Не Контекст.ПолныеПраваНаВарианты Тогда
		Элементы.ГруппаДоступен.ТолькоПросмотр = Истина;
	КонецЕсли;

	Если Контекст.ЭтоВнешний Тогда
		Элементы.ОписаниеВнешнегоОтчета.Видимость				= Истина;
		Элементы.ВариантВидимостьПоУмолчанию.Видимость			= Ложь;
		Элементы.Назад.Видимость								= Ложь;
		Элементы.Далее.Видимость								= Ложь;
		Элементы.ГруппаДоступен.Видимость						= Ложь;
		Элементы.ДекорацияЧтоБудетДальшеНовый.Заголовок			= Лев(Элементы.ДекорацияЧтоБудетДальшеНовый.Заголовок, СтрНайти(Элементы.ДекорацияЧтоБудетДальшеНовый.Заголовок, Символы.ПС) - 1);
		Элементы.ДекорацияЧтоБудетДальшеПерезапись.Заголовок	= Лев(Элементы.ДекорацияЧтоБудетДальшеПерезапись.Заголовок, СтрНайти(Элементы.ДекорацияЧтоБудетДальшеПерезапись.Заголовок, Символы.ПС ) - 1);
	КонецЕсли;

	ВидимостьДоступность(ЭтотОбъект, "ПриСозданииНаСервере");
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Не ЗначениеЗаполнено(ВариантНаименование) Тогда
		БазоваяПодсистемаКлиентСервер.СообщитьПользователю("Поле ""Наименование"" не заполнено", , "Наименование");
		Отказ = Истина;
	ИначеЕсли ВариантыОтчетовСервер.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, ВариантНаименование) Тогда
		БазоваяПодсистемаКлиентСервер.СообщитьПользователю(СтрШаблон("""%1"" занято, необходимо указать другое Наименование.", ВариантНаименование), , "Наименование");
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник = ИмяФормы Тогда
		Возврат;
	КонецЕсли;

	Если ИмяСобытия = "СтандартныеПодсистемы.ИзменениеВарианта" Или ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВариантов(Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТекущийЭлемент = Элементы.Наименование;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	НаименованиеМодифицировано				= Истина;
	Элементы.ВариантыОтчета.ТекущаяСтрока	= Контекст.ПоискПоНаименованию.Получить(ВариантНаименование);
	ВидимостьДоступность(ЭтотОбъект, "НаименованиеПриИзменении");
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	ВариантТолькоДляАвтора = (Доступен = "ТолькоАвтор");
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ОписаниеНачалоВыбораЗавершение", ЭтотОбъект);
	БазоваяПодсистемаКлиент.ПоказатьФормуРедактированияМногострочногоТекста(Оповещение, Элементы.Описание.ТекстРедактирования, "Описание");
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	ОписаниеМодифицировано = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВариантыОтчета

&НаКлиенте
Процедура ВариантыОтчетаПриАктивизацииСтроки(Элемент)
	НаименованиеМодифицировано	= Ложь;
	ОписаниеМодифицировано		= Ложь;
	ВидимостьДоступность(ЭтотОбъект, "ВариантыОтчетаПриАктивизацииСтроки");
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	СохранитьИЗакрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;

	Вариант = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	Если Не ПравоНастройкиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
		ТекстПредупреждения = "Недостаточно прав доступа для изменения варианта ""%1"".";
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);

		Возврат;
	КонецЕсли;
	ВариантыОтчетовКлиент.ПоказатьНастройкиОтчета(Вариант.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередУдалением(Элемент, Отказ)
	Отказ = Истина;
	Вариант = Элементы.ВариантыОтчета.ТекущиеДанные;
	Если Вариант = Неопределено Или Не ЗначениеЗаполнено(Вариант.Ссылка) Тогда
		Возврат;
	КонецЕсли;

	Если Не Контекст.ПолныеПраваНаВарианты И Не Вариант.АвторТекущийПользователь Тогда
		ТекстПредупреждения = "Недостаточно прав для удаления варианта отчета ""%1"".";
		ТекстПредупреждения = СтрШаблон(ТекстПредупреждения, Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);

		Возврат;
	КонецЕсли;

	Если Не Вариант.Пользовательский Тогда
		ПоказатьПредупреждение(, "Невозможно удалить предопределенный вариант отчета.");
		Возврат;
	КонецЕсли;

	Если Вариант.ПометкаУдаления Тогда
		ТекстВопроса = "Снять с ""%1"" пометку на удаление?";
	Иначе
		ТекстВопроса = "Пометить ""%1"" на удаление?";
	КонецЕсли;
	ТекстВопроса = СтрШаблон(ТекстВопроса, Вариант.Наименование);

	ДополнительныеПараметры	= Новый Структура;
	ДополнительныеПараметры.Вставить("Идентификатор", Вариант.ПолучитьИдентификатор());
	Обработчик				= Новый ОписаниеОповещения("ВариантыОтчетаПередУдалениемЗавершение", ЭтотОбъект, ДополнительныеПараметры);

	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередУдалениемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Да Тогда
		УдалитьВариантНаСервере(ДополнительныеПараметры.Идентификатор);
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыОтчетаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПодсистем

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	ПерейтиНаСтраницу1();
КонецПроцедуры

&НаКлиенте
Процедура Далее(Команда)
	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",       Истина);
	Пакет.Вставить("ПерейтиНаСтраницу2",       Истина);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер", Истина);
	Пакет.Вставить("ПроверитьИЗаписатьСервер", Ложь);
	Пакет.Вставить("ЗакрытьПослеЗаписи",       Ложь);
	Пакет.Вставить("ТекущийШаг", Неопределено);

	ВыполнитьПакет(Неопределено, Пакет);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьИЗакрыть();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);

	ОтборЭлемента					= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ВариантыОтчета.Пользовательский");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);

	ГруппаОтбора			= Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы	= ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента					= ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ПолныеПраваНаВарианты");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= Ложь;

	ОтборЭлемента					= ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ВариантыОтчета.АвторТекущийПользователь");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);

	Элемент	= УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчета.Имя);
	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ВариантыОтчетаНаименование.Имя);

	ОтборЭлемента					= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ВариантыОтчета.Порядок");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= 3;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СкрытыйВариантОтчетаЦвет);

	ВариантыОтчетовСервер.УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПакет(Результат, Пакет) Экспорт
	Если Не Пакет.Свойство("ВариантЭтоНовый") Тогда
		Пакет.Вставить("ВариантЭтоНовый", Не ЗначениеЗаполнено(ВариантСсылка));
	КонецЕсли;

	// Обработка результата предыдущего шага.
	Если Пакет.ТекущийШаг = "ВопросНаПерезапись" Тогда
		Пакет.ТекущийШаг = Неопределено;
		Если Результат = КодВозвратаДиалога.Да Тогда
			Пакет.Вставить("ВопросНаПерезаписьПройден", Истина);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;

	// Выполнение следующего шага.
	Если Пакет.ПроверитьСтраницу1 = Истина Тогда
		// Наименование не введено.
		Если Не ЗначениеЗаполнено(ВариантНаименование) Тогда
			ТекстОшибки = "Поле ""Наименование"" не заполнено";
			БазоваяПодсистемаКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ВариантНаименование");

			Возврат;
		КонецЕсли;

		// Введено наименование существующего варианта отчета.
		Если Не Пакет.ВариантЭтоНовый Тогда
			Найденные	= ВариантыОтчета.НайтиСтроки(Новый Структура("Ссылка", ВариантСсылка));
			Вариант		= Найденные[0];
			Если Не ПравоЗаписиВарианта(Вариант, Контекст.ПолныеПраваНаВарианты) Тогда
				ТекстОшибки = "Недостаточно прав для изменения варианта ""%1"". Необходимо выбрать другой вариант или изменить Наименование.";
				ТекстОшибки = СтрШаблон(ТекстОшибки, ВариантНаименование);
				БазоваяПодсистемаКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ВариантНаименование");

				Возврат;
			КонецЕсли;

			Если Не Пакет.Свойство("ВопросНаПерезаписьПройден") Тогда
				Если Вариант.ПометкаУдаления = Истина Тогда
					ТекстВопроса		= "Вариант отчета ""%1"" помечен на удаление.
					|Заменить помеченный на удаление вариант отчета?";
					КнопкаПоУмолчанию	= КодВозвратаДиалога.Нет;
				Иначе
					ТекстВопроса		= "Заменить ранее сохраненный вариант отчета ""%1""?";
					КнопкаПоУмолчанию	= КодВозвратаДиалога.Да;
				КонецЕсли;
				ТекстВопроса		= СтрШаблон(ТекстВопроса, ВариантНаименование);
				Пакет.ТекущийШаг	= "ВопросНаПерезапись";
				Обработчик			= Новый ОписаниеОповещения("ВыполнитьПакет", ЭтотОбъект, Пакет);
				ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КнопкаПоУмолчанию);

				Возврат;
			КонецЕсли;
		КонецЕсли;

		// Проверка завершена.
		Пакет.ПроверитьСтраницу1 = Ложь;
	КонецЕсли;

	Если Пакет.ПерейтиНаСтраницу2 = Истина Тогда
		// Для внешних отчетов выполняются только проверки заполнения, без переключения страницы.
		Если Не Контекст.ЭтоВнешний Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Страница2;
			Элементы.Назад.Доступность        = Истина;
			Элементы.Далее.Доступность        = Ложь;
		КонецЕсли;

		// Переключение выполнено.
		Пакет.ПерейтиНаСтраницу2 = Ложь;
	КонецЕсли;

	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина Или Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		ВыполнитьПакетСервер(Пакет);

		СтрокиДерева = ДеревоПодсистем.ПолучитьЭлементы();
		Для Каждого СтрокаДерева Из СтрокиДерева Цикл
			Элементы.ДеревоПодсистем.Развернуть(СтрокаДерева.ПолучитьИдентификатор(), Истина);
		КонецЦикла;

		Если Пакет.Отказ = Истина Тогда
			ПерейтиНаСтраницу1();

			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если Пакет.ЗакрытьПослеЗаписи = Истина Тогда
		ВариантыОтчетовКлиент.ОбновитьОткрытыеФормы(, ИмяФормы);
		Закрыть(Новый ВыборНастроек(ВариантКлючВарианта));
		Пакет.ЗакрытьПослеЗаписи = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаСтраницу1()
	Элементы.Страницы.ТекущаяСтраница = Элементы.Страница1;
	Элементы.Назад.Доступность        = Ложь;
	Элементы.Далее.Заголовок          = "";
	Элементы.Далее.Доступность        = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть()
	Страница2Заполнена = (Элементы.Страницы.ТекущаяСтраница = Элементы.Страница2);

	Пакет = Новый Структура;
	Пакет.Вставить("ПроверитьСтраницу1",		Не Страница2Заполнена);
	Пакет.Вставить("ПерейтиНаСтраницу2",		Не Страница2Заполнена);
	Пакет.Вставить("ЗаполнитьСтраницу2Сервер",	Не Страница2Заполнена);
	Пакет.Вставить("ПроверитьИЗаписатьСервер",	Истина);
	Пакет.Вставить("ЗакрытьПослеЗаписи",		Истина);
	Пакет.Вставить("ТекущийШаг",				Неопределено);

	ВыполнитьПакет(Неопределено, Пакет);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбораЗавершение(Знач ВведенныйТекст, Знач ДополнительныеПараметры) Экспорт
	Если ВведенныйТекст = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВариантОписание = ВведенныйТекст;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма, ИмяСобытия)
	Если ИмяСобытия = "ПриСозданииНаСервере" Или ИмяСобытия = "НаименованиеПриИзменении" Или ИмяСобытия = "ПослеЗаполненияСпискаВариантов" Или ИмяСобытия = "ВариантыОтчетаПриАктивизацииСтроки" Тогда
		БудетЗаписанНовый				= Ложь;
		БудетПерезаписанСуществующий	= Ложь;
		ПерезаписьНевозможна			= Ложь;

		Идентификатор = Форма.Элементы.ВариантыОтчета.ТекущаяСтрока;
		Если Идентификатор = Неопределено Тогда // Платформа не принимает в методе НайтиПоИдентификатору значение Неопределено.
			Вариант = Неопределено;
		Иначе
			Вариант = Форма.ВариантыОтчета.НайтиПоИдентификатору(Идентификатор);
		КонецЕсли;

		Если Вариант = Неопределено Тогда
			БудетЗаписанНовый					= Истина;
			Форма.ВариантСсылка					= Неопределено;
			Форма.ВариантВидимостьПоУмолчанию	= Истина;
			Если Не Форма.ОписаниеМодифицировано Тогда
				Форма.ВариантОписание = "";
			КонецЕсли;
			Форма.Элементы.ВариантыОтчета.ТекущаяСтрока = Неопределено;
			Если Не Форма.Контекст.ПолныеПраваНаВарианты Тогда
				Форма.ВариантТолькоДляАвтора = Истина;
			КонецЕсли;
		Иначе
			ПравоЗаписиВарианта = ПравоЗаписиВарианта(Вариант, Форма.Контекст.ПолныеПраваНаВарианты);
			Если ПравоЗаписиВарианта Тогда
				БудетПерезаписанСуществующий		= Истина;
				Форма.НаименованиеМодифицировано	= Ложь;
				Форма.ВариантНаименование			= Вариант.Наименование;

				Форма.ВариантСсылка					= Вариант.Ссылка;
				Форма.ВариантТолькоДляАвтора		= Вариант.ТолькоДляАвтора;
				Форма.ВариантВидимостьПоУмолчанию	= Вариант.ВидимостьПоУмолчанию;
				Если Не Форма.ОписаниеМодифицировано Тогда
					Форма.ВариантОписание = Вариант.Описание;
				КонецЕсли;
			Иначе
				Если Форма.НаименованиеМодифицировано Тогда
					ПерезаписьНевозможна						= Истина;
					Форма.Элементы.ВариантыОтчета.ТекущаяСтрока = Неопределено;
				Иначе
					БудетЗаписанНовый			= Истина;
					Форма.ВариантНаименование	= СформироватьСвободноеНаименование(Вариант, Форма.ВариантыОтчета);
				КонецЕсли;

				Форма.ВариантСсылка					= Неопределено;
				Форма.ВариантТолькоДляАвтора		= Истина;
				Форма.ВариантВидимостьПоУмолчанию	= Истина;
				Если Не Форма.ОписаниеМодифицировано Тогда
					Форма.ВариантОписание = "";
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Форма.Доступен = ?(Форма.ВариантТолькоДляАвтора, "ТолькоАвтор", "ВсеПользователи");
		Если БудетЗаписанНовый Тогда
			Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница	= Форма.Элементы.Новый;
			Форма.Элементы.СтраницыСбросить.ТекущаяСтраница = Форма.Элементы.ФлажокСброситьСкрыт;
			Форма.Элементы.Далее.Доступность				= Истина;
			Форма.Элементы.Сохранить.Доступность			= Истина;
		ИначеЕсли БудетПерезаписанСуществующий Тогда
			Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница   = Форма.Элементы.Перезапись;
			Форма.Элементы.СтраницыСбросить.ТекущаяСтраница = Форма.Элементы.ФлажокСброситьВиден;
			Форма.Элементы.Далее.Доступность				= Истина;
			Форма.Элементы.Сохранить.Доступность			= Истина;
		ИначеЕсли ПерезаписьНевозможна Тогда
			Форма.Элементы.ЧтоБудетДальше.ТекущаяСтраница   = Форма.Элементы.ПерезаписьНевозможна;
			Форма.Элементы.СтраницыСбросить.ТекущаяСтраница = Форма.Элементы.ФлажокСброситьСкрыт;
			Форма.Элементы.Далее.Доступность				= Ложь;
			Форма.Элементы.Сохранить.Доступность			= Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат (ПолныеПраваНаВарианты Или Вариант.АвторТекущийПользователь) И ЗначениеЗаполнено(Вариант.Ссылка);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПравоЗаписиВарианта(Вариант, ПолныеПраваНаВарианты)
	Возврат Вариант.Пользовательский И ПравоНастройкиВарианта(Вариант, ПолныеПраваНаВарианты);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьСвободноеНаименование(Вариант, ВариантыОтчета)
	ШаблонИмениВарианта		= СокрЛП(Вариант.Наименование) +" - копия";

	СвободноеНаименование	= ШаблонИмениВарианта;
	Найденные				= ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
	Если Найденные.Количество() = 0 Тогда
		Возврат СвободноеНаименование;
	КонецЕсли;

	НомерВарианта = 1;
	Пока Истина Цикл
		НомерВарианта			= НомерВарианта + 1;
		СвободноеНаименование	= ШаблонИмениВарианта +" (" + Формат(НомерВарианта, "") + ")";
		Найденные				= ВариантыОтчета.НайтиСтроки(Новый Структура("Наименование", СвободноеНаименование));
		Если Найденные.Количество() = 0 Тогда
			Возврат СвободноеНаименование;
		КонецЕсли;
	КонецЦикла;
КонецФункции

&НаСервере
Процедура ВыполнитьПакетСервер(Пакет)
	Пакет.Вставить("Отказ", Ложь);

	Если Пакет.ЗаполнитьСтраницу2Сервер = Истина Тогда
		Если Не Контекст.ЭтоВнешний Тогда
			ПерезаполнитьВторуюСтраницу(Пакет);
		КонецЕсли;
		Пакет.ЗаполнитьСтраницу2Сервер = Ложь;
	КонецЕсли;

	Если Пакет.ПроверитьИЗаписатьСервер = Истина Тогда
		ПроверитьИЗаписатьНаСервере(Пакет);
		Пакет.ПроверитьИЗаписатьСервер = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьВариантНаСервере(Идентификатор)
	Если Идентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Вариант = ВариантыОтчета.НайтиПоИдентификатору(Идентификатор);
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПометкаУдаления			= Не Вариант.ПометкаУдаления;
	ВариантОбъект			= Вариант.Ссылка.ПолучитьОбъект();
	ВариантОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	Вариант.ПометкаУдаления	= ПометкаУдаления;
	Вариант.ИндексКартинки	= ?(ПометкаУдаления, 4, ?(ВариантОбъект.Пользовательский, 3, 5));
КонецПроцедуры

&НаСервере
Процедура ПерезаполнитьВторуюСтраницу(Пакет)
	Если Пакет.ВариантЭтоНовый Тогда
		ВариантОснование = ПрототипСсылка;
	Иначе
		ВариантОснование = ВариантСсылка;
	КонецЕсли;

	ДеревоПриемник = ВариантыОтчетовСервер.ДеревоПодсистемСформировать(ЭтотОбъект, ВариантОснование);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
КонецПроцедуры

&НаСервере
Процедура ПроверитьИЗаписатьНаСервере(Пакет)
	ЭтоНовыйВариантОтчета = Не ЗначениеЗаполнено(ВариантСсылка);

	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Если Не ЭтоНовыйВариантОтчета Тогда
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ВариантСсылка);
		КонецЕсли;
		Блокировка.Заблокировать();

		Если ЭтоНовыйВариантОтчета И ВариантыОтчетовСервер.НаименованиеЗанято(Контекст.ОтчетСсылка, ВариантСсылка, ВариантНаименование) Тогда
			ТекстОшибки = СтрШаблон("""%1"" занято, необходимо указать другое Наименование.", ВариантНаименование);
			БазоваяПодсистемаКлиентСервер.СообщитьПользователю(ТекстОшибки, , "ВариантНаименование");
			Пакет.Отказ = Истина;

			Возврат;
		КонецЕсли;

		Если ЭтоНовыйВариантОтчета Тогда
			ВариантОбъект					= Справочники.ВариантыОтчетов.СоздатьЭлемент();
			ВариантОбъект.Отчет				= Контекст.ОтчетСсылка;
			ВариантОбъект.ТипОтчета			= Контекст.ТипОтчета;
			ВариантОбъект.КлючВарианта		= Строка(Новый УникальныйИдентификатор());
			ВариантОбъект.Пользовательский	= Истина;
			ВариантОбъект.Автор				= Контекст.ТекущийПользователь;
			Если ПрототипПредопределенный Тогда
				ВариантОбъект.Родитель = ПрототипСсылка;
			ИначеЕсли ТипЗнч(ПрототипСсылка) = Тип("СправочникСсылка.ВариантыОтчетов") И Не ПрототипСсылка.Пустая() Тогда
				ВариантОбъект.Родитель = БазоваяПодсистемаСервер.ЗначениеРеквизитаОбъекта(ПрототипСсылка, "Родитель");
			Иначе
				ВариантОбъект.ЗаполнитьРодителя();
			КонецЕсли;
		Иначе
			ВариантОбъект = ВариантСсылка.ПолучитьОбъект();
		КонецЕсли;

		Если Контекст.ЭтоВнешний Тогда
			ВариантОбъект.Размещение.Очистить();
		Иначе
			ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
			Если ЭтоНовыйВариантОтчета Тогда
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
			Иначе
				ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
			КонецЕсли;
			ВариантыОтчетовСервер.ДеревоПодсистемЗаписать(ВариантОбъект, ИзмененныеРазделы);
		КонецЕсли;

		ВариантОбъект.Наименование			= ВариантНаименование;
		ВариантОбъект.Описание				= ВариантОписание;
		ВариантОбъект.ТолькоДляАвтора		= ВариантТолькоДляАвтора;
		ВариантОбъект.ВидимостьПоУмолчанию	= ВариантВидимостьПоУмолчанию;

		ВариантОбъект.Записать();

		ВариантСсылка       = ВариантОбъект.Ссылка;
		ВариантКлючВарианта = ВариантОбъект.КлючВарианта;

		Если СброситьНастройки Тогда
			ВариантыОтчетовСервер.СброситьПользовательскиеНастройки(ВариантОбъект.Ссылка);
		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВариантов(ОбновитьФорму)
	ТекущийКлючВарианта = ПрототипКлюч;

	// Подмена на ключ варианта "до перезаполнения".
	ИдентификаторТекущейСтроки = Элементы.ВариантыОтчета.ТекущаяСтрока;
	Если ИдентификаторТекущейСтроки <> Неопределено Тогда
		ТекущаяСтрока = ВариантыОтчета.НайтиПоИдентификатору(ИдентификаторТекущейСтроки);
		Если ТекущаяСтрока <> Неопределено Тогда
			ТекущийКлючВарианта = ТекущаяСтрока.КлючВарианта;
		КонецЕсли;
	КонецЕсли;

	ВариантыОтчета.Очистить();

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	            	  |	ВариантыОтчетов.Ссылка КАК Ссылка,
	            	  |	ВариантыОтчетов.Пользовательский КАК Пользовательский,
	            	  |	ВариантыОтчетов.Наименование КАК Наименование,
	            	  |	ВариантыОтчетов.Автор КАК Автор,
	            	  |	ВариантыОтчетов.Описание КАК Описание,
	            	  |	ВариантыОтчетов.ТипОтчета КАК Тип,
	            	  |	ВариантыОтчетов.КлючВарианта КАК КлючВарианта,
	            	  |	ВариантыОтчетов.ТолькоДляАвтора КАК ТолькоДляАвтора,
	            	  |	ВариантыОтчетов.ВидимостьПоУмолчанию КАК ВидимостьПоУмолчанию,
	            	  |	ВариантыОтчетов.ПометкаУдаления КАК ПометкаУдаления,
	            	  |	ВЫБОР
	            	  |		КОГДА ВариантыОтчетов.Автор = &ТекущийПользователь
	            	  |			ТОГДА ИСТИНА
	            	  |		ИНАЧЕ ЛОЖЬ
	            	  |	КОНЕЦ КАК АвторТекущийПользователь,
	            	  |	ВЫБОР
	            	  |		КОГДА ВариантыОтчетов.ПометкаУдаления
	            	  |			ТОГДА 4
	            	  |		КОГДА ВариантыОтчетов.Пользовательский
	            	  |			ТОГДА 3
	            	  |		ИНАЧЕ 5
	            	  |	КОНЕЦ КАК ИндексКартинки,
	            	  |	ВЫБОР
	            	  |		КОГДА ВариантыОтчетов.ПометкаУдаления
	            	  |			ТОГДА 3
	            	  |		КОГДА ВариантыОтчетов.Пользовательский
	            	  |			ТОГДА 2
	            	  |		ИНАЧЕ 1
	            	  |	КОНЕЦ КАК Порядок
	            	  |ИЗ
	            	  |	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	            	  |ГДЕ
	            	  |	ВариантыОтчетов.Отчет = &Отчет
	            	  |	И НЕ(НЕ ВариантыОтчетов.ПометкаУдаления = ЛОЖЬ
	            	  |				И НЕ ВариантыОтчетов.Пользовательский = ИСТИНА)
	            	  |	И НЕ(НЕ ВариантыОтчетов.ТолькоДляАвтора = ЛОЖЬ
	            	  |				И НЕ ВариантыОтчетов.Автор = &ТекущийПользователь
	            	  |				И НЕ ВариантыОтчетов.КлючВарианта = &ПрототипКлюч
	            	  |				И НЕ ВариантыОтчетов.КлючВарианта = &ТекущийКлючВарианта)
	            	  |	И НЕ ВариантыОтчетов.ПредопределенныйВариант В (&ОтключенныеВариантыПрограммы)";

	Запрос.УстановитьПараметр("Отчет",							Контекст.ОтчетСсылка);
	Запрос.УстановитьПараметр("ПрототипКлюч",					ПрототипКлюч);
	Запрос.УстановитьПараметр("ТекущийКлючВарианта",			ТекущийКлючВарианта);
	Запрос.УстановитьПараметр("ТекущийПользователь",			Контекст.ТекущийПользователь);
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы",	ВариантыОтчетовСерверПовтИсп.ОтключенныеВариантыПрограммы());

	ТаблицаЗначений = Запрос.Выполнить().Выгрузить();

	ВариантыОтчета.Загрузить(ТаблицаЗначений);

	// Добавить предопределенные варианты внешнего отчета.
	Если Контекст.ЭтоВнешний Тогда
		Попытка
			ОтчетОбъект = ВнешниеОтчеты.Создать(Контекст.ОтчетИмя);
		Исключение
			ВариантыОтчетовСервер.ЗаписатьВЖурнал(УровеньЖурналаРегистрации.Ошибка,
				СтрШаблон("Не удалось получить список предопределенных вариантов
						|внешнего отчета ""%1"":",
					Контекст.ОтчетСсылка)
				+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

			Возврат;
		КонецПопытки;

		Если ОтчетОбъект.СхемаКомпоновкиДанных = Неопределено Тогда
			Возврат;
		КонецЕсли;

		Для Каждого ВариантНастроекКД Из ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек Цикл
			Вариант								= ВариантыОтчета.Добавить();
			Вариант.Пользовательский			= Ложь;
			Вариант.Наименование				= ВариантНастроекКД.Представление;
			Вариант.КлючВарианта				= ВариантНастроекКД.Имя;
			Вариант.ТолькоДляАвтора				= Ложь;
			Вариант.АвторТекущийПользователь	= Ложь;
			Вариант.ИндексКартинки				= 5;
		КонецЦикла;
	КонецЕсли;

	ВариантыОтчета.Сортировать("Наименование Возр");

	Контекст.ПоискПоНаименованию = Новый Соответствие;
	Для Каждого Вариант Из ВариантыОтчета Цикл
		Идентификатор = Вариант.ПолучитьИдентификатор();
		Контекст.ПоискПоНаименованию.Вставить(Вариант.Наименование, Идентификатор);
		Если Вариант.КлючВарианта = ПрототипКлюч Тогда
			ПрототипСсылка           = Вариант.Ссылка;
			ПрототипПредопределенный = Не Вариант.Пользовательский;
		КонецЕсли;
		Если Вариант.КлючВарианта = ТекущийКлючВарианта Тогда
			Элементы.ВариантыОтчета.ТекущаяСтрока = Идентификатор;
		КонецЕсли;
	КонецЦикла;

	ВидимостьДоступность(ЭтотОбъект, "ПослеЗаполненияСпискаВариантов");
КонецПроцедуры
