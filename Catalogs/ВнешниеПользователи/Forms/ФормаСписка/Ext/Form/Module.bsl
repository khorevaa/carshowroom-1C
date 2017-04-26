﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ПоследнийЭлемент;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Начальное значение настройки до загрузки данных из настроек.
	ВыбиратьИерархически	= Истина;

	ХранимыеПараметры		= Новый Структура;
	ХранимыеПараметры.Вставить("ВыборГруппВнешнихПользователей", Параметры.ВыборГруппВнешнихПользователей);

	Если Параметры.Отбор.Свойство("ОбъектАвторизации") Тогда
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Параметры.Отбор.ОбъектАвторизации);
	Иначе
		ХранимыеПараметры.Вставить("ОтборОбъектАвторизации", Неопределено);
	КонецЕсли;

	МассивПустыхСсылок = Неопределено;
	Параметры.Свойство("Назначение", МассивПустыхСсылок);
	ЗаполнитьПараметрыДинамическихСписков(МассивПустыхСсылок);

	Если Параметры.РежимВыбора Тогда
		БазоваяПодсистемаСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ИначеЕсли ПользователиСервер.ЭтоПолноправныйПользователь() Тогда
		// Добавление отбора пользователей, подготовленных ответственным за список.
		БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "Подготовлен", Истина, , "Подготовленные ответственным за список", Ложь, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
	КонецЕсли;

	// Скрытие пользователей с пустым идентификатором, если значение параметра Истина.
	Если Параметры.СкрытьПользователейБезПользователяИБ Тогда
		БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "ИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"), ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;

	// Скрытие переданного пользователя из формы выбора пользователей.
	Если ТипЗнч(Параметры.СкрываемыеПользователи) = Тип("СписокЗначений") Тогда
		ВидСравненияКД = ВидСравненияКомпоновкиДанных.НеВСписке;
		БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "Ссылка", Параметры.СкрываемыеПользователи, ВидСравненияКД);
	КонецЕсли;

	// Оформление.
	ЭлементУсловногоОформления				= УсловноеОформление.Элементы.Добавить();

	ЭлементЦветаОформления					= ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение			= Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование	= Истина;

	ЭлементОтбораДанных						= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("ВнешниеПользователиСписок.Недействителен");
	ЭлементОтбораДанных.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение		= Истина;
	ЭлементОтбораДанных.Использование		= Истина;

	ЭлементОформляемогоПоля					= ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле			= Новый ПолеКомпоновкиДанных("ВнешниеПользователиСписок");
	ЭлементОформляемогоПоля.Использование	= Истина;

	// Скрытие.
	БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "Недействителен", Ложь, , , Истина);

	ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ИдентификаторТекущегоПользователяИБ",	ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);
	ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ПустойУникальныйИдентификатор",		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	ОбновитьЗначениеПараметраКомпоновкиДанных(ВнешниеПользователиСписок, "ВозможноСменитьТолькоСвойПароль",		Не ПользователиСервер.ЭтоПолноправныйПользователь());

	// Порядок.
	Порядок											= ГруппыВнешнихПользователей.КомпоновщикНастроек.Настройки.Порядок;
	Порядок.ИдентификаторПользовательскойНастройки	= "ОсновнойПорядок";

	Порядок.Элементы.Очистить();

	ЭлементПорядка						= Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле					= Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания	= НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование		= Истина;

	ЭлементПорядка						= Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле					= Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания	= НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование		= Истина;

	ХранимыеПараметры.Вставить("РасширенныйПодбор", Параметры.РасширенныйПодбор);
	Элементы.ВыбранныеПользователиИГруппы.Видимость	= ХранимыеПараметры.РасширенныйПодбор;
	Элементы.ВидПользователей.Видимость				= Не ХранимыеПараметры.РасширенныйПодбор;
	ХранимыеПараметры.Вставить("ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));

	Если НЕ ПравоДоступа("Добавление", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Элементы.СоздатьВнешнегоПользователя.Видимость = Ложь;
	КонецЕсли;

	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.ВнешниеПользователи) Тогда
		Элементы.ВнешниеПользователиСписокКонтекстноеМенюНазначитьГруппы.Видимость	= Ложь;
		Элементы.НазначитьГруппы.Видимость											= Ложь;
	КонецЕсли;

	Если НЕ ПользователиСервер.ЭтоПолноправныйПользователь(, Истина) Тогда
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОВнешнихПользователях.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.РежимВыбора Тогда
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОВнешнихПользователях.Видимость	= Ложь;
		Элементы.ГруппыВнешнихПользователей.РежимВыбора		= ХранимыеПараметры.ВыборГруппВнешнихПользователей;

		// Отключение перетаскивания пользователя в формах выбора и подбора пользователей.
		Элементы.ВнешниеПользователиСписок.РазрешитьНачалоПеретаскивания = Ложь;

		Если Параметры.Свойство("ИдентификаторыНесуществующихПользователейИБ") Тогда
			БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "ИдентификаторПользователяИБ", Параметры.ИдентификаторыНесуществующихПользователейИБ, ВидСравненияКомпоновкиДанных.ВСписке, , Истина, РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
		КонецЕсли;

		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.ВнешниеПользователиСписок.МножественныйВыбор = Истина;

			Если ХранимыеПараметры.РасширенныйПодбор Тогда
				БазоваяПодсистемаСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "РасширенныйПодбор");
				ИзменитьПараметрыРасширеннойФормыПодбора();
			КонецЕсли;

			Если ХранимыеПараметры.ВыборГруппВнешнихПользователей Тогда
				Элементы.ГруппыВнешнихПользователей.МножественныйВыбор = Истина;
			КонецЕсли;
		КонецЕсли;
	Иначе
		Элементы.ВнешниеПользователиСписок.РежимВыбора			= Ложь;
		Элементы.ГруппыВнешнихПользователей.РежимВыбора			= Ложь;
		Элементы.Комментарии.Видимость							= Ложь;
		Элементы.ВыбратьВнешнегоПользователя.Видимость			= Ложь;
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость	= Ложь;
	КонецЕсли;

	ХранимыеПараметры.Вставить("ГруппаВсеПользователи",	Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи);
	ХранимыеПараметры.Вставить("ТекущаяСтрока",			Параметры.ТекущаяСтрока);
	НастроитьФормуПоИспользованиюГруппПользователей();
	ХранимыеПараметры.Удалить("ТекущаяСтрока");

	Если Не ПользователиСервер.ЭтоПолноправныйПользователь() Тогда
		Элементы.ФормаИзменитьВыделенные.Видимость										= Ложь;
		Элементы.ВнешниеПользователиСписокКонтекстноеМенюИзменитьВыделенные.Видимость	= Ложь;
	КонецЕсли;

	ОписаниеОбъекта	= Новый Структура;
	ОписаниеОбъекта.Вставить("Ссылка", Справочники.Пользователи.ПустаяСсылка());
	ОписаниеОбъекта.Вставить("ИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	УровеньДоступа	= ПользователиСервер.сУровеньДоступаКСвойствамПользователя(ОписаниеОбъекта);

	Если Не УровеньДоступа.УправлениеСписком Тогда
		Элементы.ФормаУстановитьПароль.Видимость									= Ложь;
		Элементы.ВнешниеПользователиСписокКонтекстноеМенюУстановитьПароль.Видимость	= Ложь;
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.РежимВыбора Тогда
		ПроверкаИзмененияТекущегоЭлементаФормы();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ВРег(ИмяСобытия) = ВРег("Запись_ГруппыВнешнихПользователей") И Источник = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока Тогда
		Элементы.ГруппыВнешнихПользователей.Обновить();
		Элементы.ВнешниеПользователиСписок.Обновить();
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант") Тогда
		Если ВРег(Источник) = ВРег("ИспользоватьГруппыПользователей") Тогда
			ПодключитьОбработчикОжидания("ПриИзмененииИспользованияГруппПользователей", 0.1, Истина);
		КонецЕсли;
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("РазмещениеПользователейВГруппах") Тогда
		Элементы.ВнешниеПользователиСписок.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Если ТипЗнч(Настройки["ВыбиратьИерархически"]) = Тип("Булево") Тогда
		ВыбиратьИерархически = Настройки["ВыбиратьИерархически"];
	КонецЕсли;

	Если НЕ ВыбиратьИерархически Тогда
		ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВыбиратьИерархическиПриИзменении(Элемент)
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНедействительныхПользователейПриИзменении(Элемент)
	БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "Недействителен", Ложь, , , НЕ ПоказыватьНедействительныхПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ВидПользователейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект);
	ПользователиКлиент.сВыбратьНазначение(ЭтотОбъект, "Выбор вида пользователей", Ложь, Истина, ОписаниеОповещения);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыГруппыВнешнихПользователей

&НаКлиенте
Процедура ГруппыВнешнихПользователейПриАктивизацииСтроки(Элемент)
	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Если НЕ Копирование Тогда
		Отказ			= Истина;
		ПараметрыФормы	= Новый Структура;

		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", Новый Структура("Родитель", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
		КонецЕсли;

		ОткрытьФорму("Справочник.ГруппыВнешнихПользователей.ФормаОбъекта", ПараметрыФормы, Элементы.ГруппыВнешнихПользователей);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;

	Если ВыбиратьИерархически Тогда
		ПоказатьПредупреждение(,"Для перетаскивания пользователя в группы необходимо отключить
			           |флажок ""Показывать пользователей нижестоящих групп"".");
		Возврат;
	КонецЕсли;

	Если Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = Строка Или Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
		Перемещение = Истина;
	Иначе
		Перемещение = Ложь;
	КонецЕсли;

	ТекущаяСтрокаГруппы					= Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока;
	ГруппаСТипомВсеОбъектыАвторизации	= Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(ТекущаяСтрокаГруппы).ВсеОбъектыАвторизации;

	Если Строка = ХранимыеПараметры.ГруппаВсеПользователи И ГруппаСТипомВсеОбъектыАвторизации Тогда
		СообщениеПользователю = Новый Структура("Сообщение, ЕстьОшибки, Пользователи",
			"Из групп с типом участников ""Все пользователи заданного типа"" исключение пользователей невозможно.",
			Истина,
			Неопределено);
	Иначе
		ГруппаПомеченаНаУдаление		= Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(Строка).ПометкаУдаления;

		КоличествоПользователей			= ПараметрыПеретаскивания.Значение.Количество();

		ДействиеИсключитьПользователя	= (ХранимыеПараметры.ГруппаВсеПользователи = Строка);

		ДействиеСПользователем			= ?((ХранимыеПараметры.ГруппаВсеПользователи = ТекущаяСтрокаГруппы) ИЛИ ГруппаСТипомВсеОбъектыАвторизации, "Включить", ?(Перемещение, "Переместить", "Скопировать"));

		Если ГруппаПомеченаНаУдаление Тогда
			ШаблонДействия			= ?(Перемещение, "Группа ""%1"" помечена на удаление. %2", "Группа ""%1"" помечена на удаление. %2");
			ДействиеСПользователем	= СтрШаблон(ШаблонДействия, Строка(Строка), ДействиеСПользователем);
		КонецЕсли;

		Если КоличествоПользователей = 1 Тогда
			Если ДействиеИсключитьПользователя Тогда
				ТекстВопроса = СтрШаблон("Исключить пользователя ""%1"" из группы ""%2""?", Строка(ПараметрыПеретаскивания.Значение[0]), Строка(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
			ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
				ТекстВопроса = СтрШаблон("%1 пользователя ""%2"" в группу ""%3""?", ДействиеСПользователем, Строка(ПараметрыПеретаскивания.Значение[0]), Строка(Строка));
			Иначе
				ТекстВопроса = СтрШаблон("%1 пользователя ""%2"" в эту группу?", ДействиеСПользователем, Строка(ПараметрыПеретаскивания.Значение[0]));
			КонецЕсли;
		Иначе
			Если ДействиеИсключитьПользователя Тогда
				ТекстВопроса = СтрШаблон("Исключить пользователей (%1) из группы ""%2""?", КоличествоПользователей, Строка(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока));
			ИначеЕсли Не ГруппаПомеченаНаУдаление Тогда
				ТекстВопроса = СтрШаблон("%1 пользователей (%2) в группу ""%3""?", ДействиеСПользователем, КоличествоПользователей, Строка(Строка));
			Иначе
				ТекстВопроса = СтрШаблон("%1 пользователей (%2) в эту группу?", ДействиеСПользователем, КоличествоПользователей);
			КонецЕсли;
		КонецЕсли;

		ДополнительныеПараметры	= Новый Структура("ПараметрыПеретаскивания, Строка, Перемещение", ПараметрыПеретаскивания.Значение, Строка, Перемещение);
		Оповещение				= Новый ОписаниеОповещения("ГруппыВнешнихПользователейПеретаскиваниеОбработкаВопроса", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 60, КодВозвратаДиалога.Да);

		Возврат;
	КонецЕсли;

	ГруппыВнешнихПользователейПеретаскиваниеЗавершение(СообщениеПользователю);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВнешниеПользователи

&НаКлиенте
Процедура ВнешниеПользователиСписокПриАктивизацииСтроки(Элемент)
	Если БазоваяПодсистемаКлиент.ЭтоЭлементДинамическогоСписка(Элементы.ВнешниеПользователиСписок) Тогда
		ВозможноСменитьПароль = Элементы.ВнешниеПользователиСписок.ТекущиеДанные.ВозможноСменитьПароль;
	Иначе
		ВозможноСменитьПароль = Ложь;
	КонецЕсли;

	Элементы.ФормаУстановитьПароль.Доступность										= ВозможноСменитьПароль;
	Элементы.ВнешниеПользователиСписокКонтекстноеМенюУстановитьПароль.Доступность	= ВозможноСменитьПароль;
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если Не ХранимыеПараметры.РасширенныйПодбор Тогда
		ОповеститьОВыборе(Значение);
	Иначе
		ПолучитьКартинкиИЗаполнитьСписокВыбранных(Значение);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;

	ПараметрыФормы = Новый Структура("ГруппаНовогоВнешнегоПользователя", Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);

	Если ЗначениеЗаполнено(ХранимыеПараметры.ОтборОбъектАвторизации) Тогда
		ПараметрыФормы.Вставить("ОбъектАвторизацииНовогоВнешнегоПользователя", ХранимыеПараметры.ОтборОбъектАвторизации);
	КонецЕсли;

	Если Копирование И Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элемент.ТекущаяСтрока);
	КонецЕсли;

	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаОбъекта", ПараметрыФормы, Элементы.ВнешниеПользователиСписок);
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;

	Если Не ЗначениеЗаполнено(Элемент.ТекущаяСтрока) Тогда
		Возврат;
	КонецЕсли;

	ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаОбъекта", ПараметрыФормы, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВнешниеПользователиСписокПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокВыбранныхПользователейИГрупп

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	УдалитьИзСпискаВыбранных();
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбранныхПользователейИГруппПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьГруппуВнешнихПользователей(Команда)
	ТекущиеДанные = Элементы.ГруппыВнешнихПользователей.ТекущиеДанные;
	Если Не БазоваяПодсистемаКлиент.ЭтоЭлементДинамическогоСписка(ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;

	Если ТекущиеДанные.ВсеОбъектыАвторизации Тогда
		ПоказатьПредупреждение(, СтрШаблон("Невозможно добавить подгруппу к группе ""%1"",
			           |так как в число ее участников входят все пользователи выбранных видов.",
			ТекущиеДанные.Наименование));
		Возврат;
	КонецЕсли;

	Элементы.ГруппыВнешнихПользователей.ДобавитьСтроку();
КонецПроцедуры

&НаКлиенте
Процедура НазначитьГруппы(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователи", Элементы.ВнешниеПользователиСписок.ВыделенныеСтроки);
	ПараметрыФормы.Вставить("ВнешниеПользователи", Истина);

	ОткрытьФорму("ОбщаяФорма.ГруппыПользователей", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	ТекущиеДанные = Элементы.ВнешниеПользователиСписок.ТекущиеДанные;

	Если БазоваяПодсистемаКлиент.ЭтоЭлементДинамическогоСписка(ТекущиеДанные) Тогда
		ПользователиКлиент.сОткрытьФормуСменыПароля(ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьИЗакрыть(Команда)
	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		МассивПользователей = РезультатВыбора();
		ОповеститьОВыборе(МассивПользователей);
		ЭтотОбъект.Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователяКоманда(Команда)
	МассивПользователей = Элементы.ВнешниеПользователиСписок.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьВыборПользователяИлиГруппы(Команда)
	УдалитьИзСпискаВыбранных();
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСписокВыбранныхПользователейИГрупп(Команда)
	УдалитьИзСпискаВыбранных(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьГруппу(Команда)
	МассивГрупп = Элементы.ГруппыВнешнихПользователей.ВыделенныеСтроки;
	ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивГрупп);
КонецПроцедуры

&НаКлиенте
Процедура СведенияОВнешнихПользователях(Команда)
	ОткрытьФорму("Отчет.СведенияОПользователях.ФормаОбъекта", Новый Структура("КлючВарианта", "СведенияОВнешнихПользователях"), ЭтотОбъект, "СведенияОВнешнихПользователях");
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	// Зарезервировано для новых подсистем
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьПараметрыДинамическихСписков(МассивПустыхСсылок = Неопределено)
	Используется = МассивПустыхСсылок <> Неопределено И МассивПустыхСсылок.Количество() <> 0;

	БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ГруппыВнешнихПользователей, "Ссылка.Назначение.ТипПользователей", МассивПустыхСсылок, ВидСравненияКомпоновкиДанных.ВСписке, , Используется);

	МассивТипов = Новый Массив;
	Если Используется Тогда
		Для Каждого Элемент Из МассивПустыхСсылок Цикл
			МассивТипов.Добавить(ТипЗнч(Элемент));
		КонецЦикла;
	КонецЕсли;

	БазоваяПодсистемаКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ВнешниеПользователиСписок, "ТипОбъектаАвторизации",МассивТипов, ВидСравненияКомпоновкиДанных.ВСписке, , Используется);
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаИзмененияТекущегоЭлементаФормы()
	Если ТекущийЭлемент <> ПоследнийЭлемент Тогда
		Если ТекущийЭлемент = Элементы.ГруппыВнешнихПользователей Тогда
			Элементы.Комментарии.ТекущаяСтраница = Элементы.КомментарийГруппы;
		ИначеЕсли ТекущийЭлемент = Элементы.ВнешниеПользователиСписок Тогда
			Элементы.Комментарии.ТекущаяСтраница = Элементы.КомментарийПользователя;
		КонецЕсли;

		ПоследнийЭлемент = ТекущийЭлемент;
	КонецЕсли;

#Если ВебКлиент Тогда
	ПодключитьОбработчикОжидания("ПроверкаИзмененияТекущегоЭлементаФормы", 0.7, Истина);
#Иначе
	ПодключитьОбработчикОжидания("ПроверкаИзмененияТекущегоЭлементаФормы", 0.1, Истина);
#КонецЕсли
КонецПроцедуры

&НаСервере
Процедура УдалитьИзСпискаВыбранных(УдалитьВсех = Ложь)
	Если УдалитьВсех Тогда
		ВыбранныеПользователиИГруппы.Очистить();
		ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();

		Возврат;
	КонецЕсли;

	МассивЭлементовСписка = Элементы.СписокВыбранныхПользователейИГрупп.ВыделенныеСтроки;
	Для Каждого ЭлементСписка Из МассивЭлементовСписка Цикл
		ВыбранныеПользователиИГруппы.Удалить(ВыбранныеПользователиИГруппы.НайтиПоИдентификатору(ЭлементСписка));
	КонецЦикла;

	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьКартинкиИЗаполнитьСписокВыбранных(МассивВыбранныхЭлементов)
	ВыбранныеЭлементыИКартинки = Новый Массив;
	Для Каждого ВыбранныйЭлемент Из МассивВыбранныхЭлементов Цикл
		Если ТипЗнч(ВыбранныйЭлемент) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			НомерКартинки = Элементы.ВнешниеПользователиСписок.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		Иначе
			НомерКартинки = Элементы.ГруппыВнешнихПользователей.ДанныеСтроки(ВыбранныйЭлемент).НомерКартинки;
		КонецЕсли;

		ВыбранныеЭлементыИКартинки.Добавить(Новый Структура("ВыбранныйЭлемент, НомерКартинки", ВыбранныйЭлемент, НомерКартинки));
	КонецЦикла;

	ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки);
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	ВыбранныеПользователиТаблицаЗначений	= ВыбранныеПользователиИГруппы.Выгрузить( , "Пользователь");
	МассивПользователей						= ВыбранныеПользователиТаблицаЗначений.ВыгрузитьКолонку("Пользователь");

	Возврат МассивПользователей;
КонецФункции

&НаСервере
Процедура ИзменитьПараметрыРасширеннойФормыПодбора()
	// Загрузка списка выбранных пользователей.
	ПараметрыРасширеннойФормыПодбора = ПолучитьИзВременногоХранилища(Параметры.ПараметрыРасширеннойФормыПодбора);
	ВыбранныеПользователиИГруппы.Загрузить(ПараметрыРасширеннойФормыПодбора.ВыбранныеПользователи);
	ХранимыеПараметры.Вставить("ЗаголовокФормыПодбора", ПараметрыРасширеннойФормыПодбора.ЗаголовокФормыПодбора);
	ПользователиСервер.ЗаполнитьНомераКартинокПользователей(ВыбранныеПользователиИГруппы, "Пользователь", "НомерКартинки");
	// Установка параметров расширенной формы подбора.
	Элементы.ЗавершитьИЗакрыть.Видимость                      = Истина;
	Элементы.ГруппаВыбратьПользователя.Видимость              = Истина;
	// Включение видимости списка выбранных пользователей.
	Элементы.ВыбранныеПользователиИГруппы.Видимость           = Истина;
	ИспользоватьГруппыПользователей = ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	Элементы.ГруппаВыбратьГруппу.Видимость                    = ИспользоватьГруппыПользователей;
	Если ИспользоватьГруппыПользователей Тогда
		Элементы.ГруппыИПользователи.Группировка                 = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
		Элементы.ВнешниеПользователиСписок.Высота                = 5;
		Элементы.ГруппыВнешнихПользователей.Высота               = 3;
		ЭтотОбъект.Высота                                        = 17;
		// Включение отображения заголовков списков ПользователиСписок и ГруппыПользователей.
		Элементы.ГруппыВнешнихПользователей.ПоложениеЗаголовка   = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ВнешниеПользователиСписок.ПоложениеЗаголовка    = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.ВнешниеПользователиСписок.Заголовок             = НСтр("ru = 'Пользователи в группе'");
		Если ПараметрыРасширеннойФормыПодбора.Свойство("ПодборГруппНевозможен") Тогда
			Элементы.ВыбратьГруппу.Видимость                     = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ОтменитьВыборПользователя.Видимость             = Истина;
		Элементы.ОчиститьСписокВыбранных.Видимость               = Истина;
	КонецЕсли;

	// Добавление количества выбранных пользователей в заголовке выбранных пользователей и групп.
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп()
	Если ХранимыеПараметры.ИспользоватьГруппы Тогда
		ЗаголовокВыбранныеПользователиИГруппы = "Выбранные пользователи и группы (%1)";
	Иначе
		ЗаголовокВыбранныеПользователиИГруппы = "Выбранные пользователи (%1)";
	КонецЕсли;

	КоличествоПользователей = ВыбранныеПользователиИГруппы.Количество();
	Если КоличествоПользователей <> 0 Тогда
		Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = СтрШаблон(ЗаголовокВыбранныеПользователиИГруппы, КоличествоПользователей);
	Иначе
		Если ХранимыеПараметры.ИспользоватьГруппы Тогда
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = "Выбранные пользователи и группы";
		Иначе
			Элементы.СписокВыбранныхПользователейИГрупп.Заголовок = "Выбранные пользователи";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбранныхПользователейИГрупп(ВыбранныеЭлементыИКартинки)
	Для Каждого СтрокаМассива Из ВыбранныеЭлементыИКартинки Цикл
		ВыбранныйПользовательИлиГруппа	= СтрокаМассива.ВыбранныйЭлемент;
		НомерКартинки					= СтрокаМассива.НомерКартинки;

		ПараметрыОтбора	= Новый Структура("Пользователь", ВыбранныйПользовательИлиГруппа);
		Найденный		= ВыбранныеПользователиИГруппы.НайтиСтроки(ПараметрыОтбора);
		Если Найденный.Количество() = 0 Тогда
			СтрокаВыбранныеПользователи					= ВыбранныеПользователиИГруппы.Добавить();
			СтрокаВыбранныеПользователи.Пользователь	= ВыбранныйПользовательИлиГруппа;
			СтрокаВыбранныеПользователи.НомерКартинки	= НомерКартинки;
			ЭтотОбъект.Модифицированность				= Истина;
		КонецЕсли;
	КонецЦикла;

	ВыбранныеПользователиИГруппы.Сортировать("Пользователь Возр");
	ОбновитьЗаголовокСпискаВыбранныхПользователейИГрупп();
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииИспользованияГруппПользователей()
	НастроитьФормуПоИспользованиюГруппПользователей(Истина);
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоИспользованиюГруппПользователей(ИзменилосьИспользованиеГрупп = Ложь)
	Если ИзменилосьИспользованиеГрупп Тогда
		ХранимыеПараметры.Вставить("ИспользоватьГруппы", ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей"));
	КонецЕсли;

	Если ХранимыеПараметры.Свойство("ТекущаяСтрока") Тогда
		Если ТипЗнч(Параметры.ТекущаяСтрока) = Тип("СправочникСсылка.ГруппыВнешнихПользователей") Тогда
			Если ХранимыеПараметры.ИспользоватьГруппы Тогда
				Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ХранимыеПараметры.ТекущаяСтрока;
			Иначе
				Параметры.ТекущаяСтрока = Неопределено;
			КонецЕсли;
		Иначе
			ТекущийЭлемент										= Элементы.ВнешниеПользователиСписок;

			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока	= Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		КонецЕсли;
	Иначе
		Если НЕ ХранимыеПараметры.ИспользоватьГруппы И Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		КонецЕсли;
	КонецЕсли;

	Элементы.ВыбиратьИерархически.Видимость = ХранимыеПараметры.ИспользоватьГруппы;

	Если ХранимыеПараметры.РасширенныйПодбор Тогда
		Элементы.НазначитьГруппы.Видимость = Ложь;
	Иначе
		Элементы.НазначитьГруппы.Видимость = ХранимыеПараметры.ИспользоватьГруппы;
	КонецЕсли;

	Элементы.СоздатьГруппуВнешнихПользователей.Видимость = ПравоДоступа("Добавление", Метаданные.Справочники.ГруппыВнешнихПользователей) И ХранимыеПараметры.ИспользоватьГруппы;

	ВыборГруппВнешнихПользователей = ХранимыеПараметры.ВыборГруппВнешнихПользователей И ХранимыеПараметры.ИспользоватьГруппы И Параметры.РежимВыбора;

	Если Параметры.РежимВыбора Тогда
		Элементы.ВыбратьГруппуВнешнихПользователей.Видимость   =  ?(ХранимыеПараметры.РасширенныйПодбор, Ложь, ВыборГруппВнешнихПользователей);
		Элементы.ВыбратьВнешнегоПользователя.КнопкаПоУмолчанию = ?(ХранимыеПараметры.РасширенныйПодбор, Ложь, Не ВыборГруппВнешнихПользователей);
		Элементы.ВыбратьВнешнегоПользователя.Видимость         = Не ХранимыеПараметры.РасширенныйПодбор;

		АвтоЗаголовок = Ложь;

		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Если ВыборГруппВнешнихПользователей Тогда
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = "Подбор внешних пользователей и групп";
				КонецЕсли;

				Элементы.ВыбратьВнешнегоПользователя.Заголовок			= "Выбрать внешних пользователей";
				Элементы.ВыбратьГруппуВнешнихПользователей.Заголовок	= "Выбрать группы";
			Иначе
				Если ХранимыеПараметры.РасширенныйПодбор Тогда
					Заголовок = ХранимыеПараметры.ЗаголовокФормыПодбора;
				Иначе
					Заголовок = "Подбор внешних пользователей";
				КонецЕсли;
			КонецЕсли;
		Иначе
			// Режим выбора.
			Если ВыборГруппВнешнихПользователей Тогда
				Заголовок										= "Выбор внешнего пользователя или группы";

				Элементы.ВыбратьВнешнегоПользователя.Заголовок	= "Выбрать внешнего пользователя";
			Иначе
				Заголовок										= "Выбор внешнего пользователя";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ОбновитьСодержимоеФормыПриИзмененииГруппы(ЭтотОбъект);

	// Принудительное обновление видимости после изменения функциональной
	// опции без использования команды ОбновитьИнтерфейс.
	Элементы.ГруппыВнешнихПользователей.Видимость = Ложь;
	Элементы.ГруппыВнешнихПользователей.Видимость = Истина;
КонецПроцедуры

&НаСервере
Функция ПеремещениеПользователяВНовуюГруппу(МассивПользователей, НоваяГруппаВладелец, Перемещение)
	Если НоваяГруппаВладелец = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТекущаяГруппаВладелец = Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока;
	СообщениеПользователю = ПользователиСервер.сПеремещениеПользователяВНовуюГруппу(МассивПользователей, ТекущаяГруппаВладелец, НоваяГруппаВладелец, Перемещение);

	Элементы.ВнешниеПользователиСписок.Обновить();
	Элементы.ГруппыВнешнихПользователей.Обновить();

	Возврат СообщениеПользователю;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСодержимоеФормыПриИзмененииГруппы(Форма)
	Элементы						= Форма.Элементы;
	ГруппаВсеВнешниеПользователи	= ПредопределенноеЗначение("Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи");

	Если НЕ Форма.ХранимыеПараметры.ИспользоватьГруппы ИЛИ Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока = ГруппаВсеВнешниеПользователи Тогда
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ВсеВнешниеПользователи",		Истина);
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически",			Истина);
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ГруппаВнешнихПользователей",	ГруппаВсеВнешниеПользователи);
	Иначе
		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ВсеВнешниеПользователи",		Ложь);

	#Если Сервер Тогда
		Если ЗначениеЗаполнено(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока) Тогда
			ТекущиеДанные = БазоваяПодсистемаСервер.ЗначенияРеквизитовОбъекта(Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока, "ВсеОбъектыАвторизации");
		Иначе
			ТекущиеДанные = Неопределено;
		КонецЕсли;
	#Иначе
		ТекущиеДанные = Элементы.ГруппыВнешнихПользователей.ТекущиеДанные;
	#КонецЕсли

		Если ТекущиеДанные <> Неопределено И Не ТекущиеДанные.Свойство("ГруппировкаСтроки") И ТекущиеДанные.ВсеОбъектыАвторизации Тогда
			ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически",	Истина);
		Иначе
			ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ВыбиратьИерархически",	Форма.ВыбиратьИерархически);
		КонецЕсли;

		ОбновитьЗначениеПараметраКомпоновкиДанных(Форма.ВнешниеПользователиСписок, "ГруппаВнешнихПользователей",	Элементы.ГруппыВнешнихПользователей.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров, Знач ИмяПараметра, Знач ЗначениеПараметра)
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			Если Параметр.Использование И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;

			Прервать;
		КонецЕсли;
	КонецЦикла;

	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскиваниеОбработкаВопроса(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;

	СообщениеПользователю = ПеремещениеПользователяВНовуюГруппу(ДополнительныеПараметры.ПараметрыПеретаскивания, ДополнительныеПараметры.Строка, ДополнительныеПараметры.Перемещение);
	ГруппыВнешнихПользователейПеретаскиваниеЗавершение(СообщениеПользователю);
КонецПроцедуры

&НаКлиенте
Процедура ГруппыВнешнихПользователейПеретаскиваниеЗавершение(СообщениеПользователю)
	Если СообщениеПользователю.Сообщение = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Оповестить("Запись_ГруппыВнешнихПользователей");

	Если СообщениеПользователю.ЕстьОшибки = Ложь Тогда
		ПоказатьОповещениеПользователя("Перемещение пользователей", , СообщениеПользователю.Сообщение, БиблиотекаКартинок.Информация);
	Иначе
		ПараметрыПредупреждения = Новый Структура("Текст", СообщениеПользователю.Сообщение);
		Если СообщениеПользователю.Пользователи <> Неопределено Тогда
			Подробно = "Следующие пользователи не были включены в выбранную группу:";
			Подробно = Подробно + Символы.ПС + СообщениеПользователю.Пользователи;
			ПараметрыПредупреждения.Вставить("Подробно", Подробно);
		КонецЕсли;
		БазоваяПодсистемаКлиент.ВывестиПредупреждение(ЭтотОбъект, ПараметрыПредупреждения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНазначения(МассивТипов, ДополнительныеПараметры) Экспорт
	ЗаполнитьПараметрыДинамическихСписков(МассивТипов);
КонецПроцедуры
