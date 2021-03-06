﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая подсистема"
//
////////////////////////////////////////////////////////////////////////////////

// Возвращает описания всех библиотек конфигурации, включая
// описание самой конфигурации.
//
Функция ОписанияПодсистем() Экспорт
	МодулиПодсистем = Новый Массив;
	МодулиПодсистем.Добавить("ИнтеграцияПодсистемСервер");

	ПодсистемыКонфигурацииСервер.ПриДобавленииПодсистем(МодулиПодсистем);

	ОписаниеКонфигурацииНайдено	= Ложь;
	ОписанияПодсистем			= Новый Структура;
	ОписанияПодсистем.Вставить("Порядок",  Новый Массив);
	ОписанияПодсистем.Вставить("ПоИменам", Новый Соответствие);

	ВсеТребуемыеПодсистемы = Новый Соответствие;

	Для Каждого ИмяМодуля Из МодулиПодсистем Цикл
		Описание	= НовоеОписаниеПодсистемы();
		Модуль		= БазоваяПодсистемаСервер.ОбщийМодуль(ИмяМодуля);
		Модуль.ПриДобавленииПодсистемы(Описание);

		Если ОписанияПодсистем.ПоИменам.Получить(Описание.Имя) <> Неопределено Тогда
			ТекстОшибки = СтрШаблон("Ошибка при подготовке описаний подсистем:
				           |в описании подсистемы (см. процедуру %1.ПриДобавленииПодсистемы)
				           |указано имя подсистемы ""%2"", которое уже зарегистрировано ранее.",
				ИмяМодуля, Описание.Имя);

			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		Если Описание.Имя = Метаданные.Имя Тогда
			ОписаниеКонфигурацииНайдено	= Истина;
			Описание.Вставить("ЭтоКонфигурация", Истина);
		Иначе
			Описание.Вставить("ЭтоКонфигурация", Ложь);
		КонецЕсли;

		Описание.Вставить("ОсновнойСерверныйМодуль", ИмяМодуля);

		ОписанияПодсистем.ПоИменам.Вставить(Описание.Имя, Описание);
		// Настройка порядка подсистем с учетом порядка добавления основных модулей.
		ОписанияПодсистем.Порядок.Добавить(Описание.Имя);
		// Сборка всех требуемых подсистем.
		Для каждого ТребуемаяПодсистема Из Описание.ТребуемыеПодсистемы Цикл
			Если ВсеТребуемыеПодсистемы.Получить(ТребуемаяПодсистема) = Неопределено Тогда
				ВсеТребуемыеПодсистемы.Вставить(ТребуемаяПодсистема, Новый Массив);
			КонецЕсли;
			ВсеТребуемыеПодсистемы[ТребуемаяПодсистема].Добавить(Описание.Имя);
		КонецЦикла;
	КонецЦикла;

	// Проверка описания основной конфигурации.
	Если ОписаниеКонфигурацииНайдено Тогда
		Описание = ОписанияПодсистем.ПоИменам[Метаданные.Имя];

		Если Описание.Версия <> Метаданные.Версия Тогда
			ТекстОшибки = СтрШаблон("Ошибка при подготовке описаний подсистем:
				           |версия ""%2"" конфигурации ""%1"" (см. процедуру %3.ПриДобавленииПодсистемы)
				           |не совпадает с версией конфигурации в метаданных ""%4"".",
				Описание.Имя, Описание.Версия, Описание.ОсновнойСерверныйМодуль, Метаданные.Версия);

			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	Иначе
		ТекстОшибки = СтрШаблон("Ошибка при подготовке описаний подсистем:
			           |в общих модулях, указанных в процедуре ПодсистемыКонфигурацииСервер.ПриДобавленииПодсистемы
			           |не найдено описание подсистемы, совпадающей с именем конфигурации ""%1"".",
			Метаданные.Имя);

		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	// Проверка наличия всех требуемых подсистем.
	Для каждого КлючИЗначение Из ВсеТребуемыеПодсистемы Цикл
		Если ОписанияПодсистем.ПоИменам.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
			ЗависимыеПодсистемы = "";
			Для Каждого ЗависимаяПодсистема Из КлючИЗначение.Значение Цикл
				ЗависимыеПодсистемы = Символы.ПС + ЗависимаяПодсистема;
			КонецЦикла;
			ТекстОшибки = СтрШаблон("Ошибка при подготовке описаний подсистем:
				           |не найдена подсистема ""%1"" требуемая для подсистем: %2.",
				КлючИЗначение.Ключ, ЗависимыеПодсистемы);

			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	КонецЦикла;

	// Настройка порядка подсистем с учетом зависимостей.
	Для Каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		Имя		= КлючИЗначение.Ключ;
		Порядок = ОписанияПодсистем.Порядок.Найти(Имя);
		Для каждого ТребуемаяПодсистема Из КлючИЗначение.Значение.ТребуемыеПодсистемы Цикл
			ПорядокТребуемойПодсистемы = ОписанияПодсистем.Порядок.Найти(ТребуемаяПодсистема);
			Если Порядок < ПорядокТребуемойПодсистемы Тогда
				Взаимозависимость = ОписанияПодсистем.ПоИменам[ТребуемаяПодсистема].ТребуемыеПодсистемы.Найти(Имя) <> Неопределено;
				Если Взаимозависимость Тогда
					НовыйПорядок = ПорядокТребуемойПодсистемы;
				Иначе
					НовыйПорядок = ПорядокТребуемойПодсистемы + 1;
				КонецЕсли;
				Если Порядок <> НовыйПорядок Тогда
					ОписанияПодсистем.Порядок.Вставить(НовыйПорядок, Имя);
					ОписанияПодсистем.Порядок.Удалить(Порядок);
					Порядок = НовыйПорядок - 1;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	// Смещение описания конфигурации в конец массива.
	Индекс = ОписанияПодсистем.Порядок.Найти(Метаданные.Имя);
	Если ОписанияПодсистем.Порядок.Количество() > Индекс + 1 Тогда
		ОписанияПодсистем.Порядок.Удалить(Индекс);
		ОписанияПодсистем.Порядок.Добавить(Метаданные.Имя);
	КонецЕсли;

	Для Каждого КлючИЗначение Из ОписанияПодсистем.ПоИменам Цикл
		КлючИЗначение.Значение.ТребуемыеПодсистемы		= Новый ФиксированныйМассив(КлючИЗначение.Значение.ТребуемыеПодсистемы);

		ОписанияПодсистем.ПоИменам[КлючИЗначение.Ключ]	= Новый ФиксированнаяСтруктура(КлючИЗначение.Значение);
	КонецЦикла;

	Возврат БазоваяПодсистемаСервер.ФиксированныеДанные(ОписанияПодсистем);
КонецФункции

Функция НовоеОписаниеПодсистемы()
	Описание = Новый Структура;
	Описание.Вставить("Имя",    "");
	Описание.Вставить("Версия", "");
	Описание.Вставить("ТребуемыеПодсистемы", Новый Массив);

	// Свойство устанавливается автоматически.
	Описание.Вставить("ЭтоКонфигурация", Ложь);

	// Имя основного модуля библиотеки.
	// Может быть пустым для конфигурации.
	Описание.Вставить("ОсновнойСерверныйМодуль", "");

	// Режим выполнения отложенных обработчиков обновления.
	// По умолчанию Последовательно.
	Описание.Вставить("РежимВыполненияОтложенныхОбработчиков", "Последовательно");
	Описание.Вставить("ПараллельноеОтложенноеОбновлениеСВерсии", "");

	Возврат Описание;
КонецФункции

// Возвращает Истина, если привилегированный режим был установлен
// при запуске с помощью параметра UsePrivilegedMode.
//
// Поддерживается только при запуске клиентских приложений
// (внешнее соединение не поддерживается).
//
Функция ПривилегированныйРежимУстановленПриЗапуске() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	Возврат ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПривилегированныйРежимУстановленПриЗапуске") = Истина;
КонецФункции

// Возвращает соответствие имен "функциональных" подсистем и значения Истина.
// У "функциональной" подсистемы снят флажок "Включать в командный интерфейс".
//
Функция ИменаПодсистем() Экспорт
	ОтключенныеПодсистемы	= Новый Соответствие;

	Имена					= Новый Соответствие;
	ВставитьИменаПодчиненныхПодсистем(Имена, Метаданные, ОтключенныеПодсистемы);

	Возврат Новый ФиксированноеСоответствие(Имена);
КонецФункции

Процедура ВставитьИменаПодчиненныхПодсистем(Имена, РодительскаяПодсистема, ОтключенныеПодсистемы, ИмяРодительскойПодсистемы = "")
	Для Каждого ТекущаяПодсистема Из РодительскаяПодсистема.Подсистемы Цикл
		Если ТекущаяПодсистема.ВключатьВКомандныйИнтерфейс Тогда
			Продолжить;
		КонецЕсли;

		ИмяТекущейПодсистемы = ИмяРодительскойПодсистемы + ТекущаяПодсистема.Имя;
		Если ОтключенныеПодсистемы.Получить(ИмяТекущейПодсистемы) = Истина Тогда
			Продолжить;
		Иначе
			Имена.Вставить(ИмяТекущейПодсистемы, Истина);
		КонецЕсли;

		Если ТекущаяПодсистема.Подсистемы.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		ВставитьИменаПодчиненныхПодсистем(Имена, ТекущаяПодсистема, ОтключенныеПодсистемы, ИмяТекущейПодсистемы + ".");
	КонецЦикла;
КонецПроцедуры

Функция ОтключитьИдентификаторыОбъектовМетаданных() Экспорт
	ОбщиеПараметры = БазоваяПодсистемаСервер.ОбщиеПараметрыБазовойФункциональности();

	Если НЕ ОбщиеПараметры.ОтключитьИдентификаторыОбъектовМетаданных Тогда
		Возврат Ложь;
	КонецЕсли;

	ВызватьИсключение "Невозможно отключить справочник Идентификаторы объектов метаданных";

	Возврат Истина;
КонецФункции

Функция СвойстваКоллекцийОбъектовМетаданных(ОбъектыРасширений = Ложь) Экспорт
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.СвойстваКоллекцийОбъектовМетаданных(ОбъектыРасширений);
КонецФункции

Функция ТаблицаПереименованияДляТекущейВерсии() Экспорт
	Возврат Справочники.ИдентификаторыОбъектовМетаданных.ТаблицаПереименованияДляТекущейВерсии();
КонецФункции

Функция ИдентификаторыОбъектовМетаданныхПроверкаИспользования(ПроверитьОбновление = Ложь, ОбъектыРасширений = Ложь) Экспорт
	Справочники.ИдентификаторыОбъектовМетаданных.ПроверкаИспользования(ОбъектыРасширений);

	Если ПроверитьОбновление Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ДанныеОбновлены(Истина, ОбъектыРасширений);
	КонецЕсли;

	Возврат Истина;
КонецФункции

Функция ИдентификаторОбъектаМетаданныхПоПолномуИмени(ПолноеИмяОбъектаМетаданных) Экспорт
	Массив = Новый Массив;
	Массив.Добавить(ПолноеИмяОбъектаМетаданных);

	Идентификаторы = Справочники.ИдентификаторыОбъектовМетаданных.ИдентификаторыОбъектовМетаданныхСПопыткойПовтора(Массив, Истина);

	Возврат Идентификаторы.Получить(ПолноеИмяОбъектаМетаданных);
КонецФункции

// Проверяет наличие механизма платформы, предупреждающего об опасных действиях.
//
// Возвращаемое значение:
//  Булево - если Истина, тогда работает механизм предупреждений безопасности.
//
Функция ЕстьЗащитаОтОпасныхДействий() Экспорт
	Свойства = Новый Структура("ЗащитаОтОпасныхДействий, UnsafeOperationProtection");
	ЗаполнитьЗначенияСвойств(Свойства, ПользователиИнформационнойБазы.ТекущийПользователь());

	Возврат Свойства.ЗащитаОтОпасныхДействий <> Неопределено Или Свойства.UnsafeOperationProtection <> Неопределено;
КонецФункции

// Возвращает список планов обмена РИБ.
// Если конфигурация работает в модели сервиса,
// то возвращает список разделенных планов обмена РИБ.
//
Функция ПланыОбменаРИБ() Экспорт
	Результат = Новый Массив;

	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		Если Лев(ПланОбмена.Имя, 7) = "Удалить" Тогда
			Продолжить;
		КонецЕсли;

		Если ПланОбмена.РаспределеннаяИнформационнаяБаза Тогда
			Результат.Добавить(ПланОбмена.Имя);
		КонецЕсли;
	КонецЦикла;

	Возврат Результат;
КонецФункции

// Возвращает признак использования в информационной базе полного РИБ (без фильтров).
// Проверка выполняется по более точному алгоритму, если используется подсистема "Обмен данными".
//
// Параметры:
//  ФильтрПоНазначению - Строка - Уточняет, наличие какого РИБ проверяется.
//                        Допустимые значения:
//                        - Пустая строка - любого РИБ
//                        - "СФильтром" - РИБ с фильтром
//                        - "Полный" - РИБ без фильтров.
//
// Возвращаемое значение: Булево.
//
Функция ИспользуетсяРИБ(ФильтрПоНазначению = "") Экспорт
	Если УзлыРИБ(ФильтрПоНазначению).Количество() > 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

// Возвращает список используемых в информационной базе узлов РИБ (без фильтров).
// Проверка выполняется по более точному алгоритму, если используется подсистема "Обмен данными".
//
// Параметры:
//  ФильтрПоНазначению - Строка - Задает назначение узлов планов обмена РИБ, которые необходимо вернуть.
//                        Допустимые значения:
//                        - Пустая строка - будут возвращены все узлы РИБ
//                        - "СФильтром" - будут возвращены узлы РИБ с фильтром
//                        - "Полный" - будут возвращены узлы РИБ без фильтров.
//
// Возвращаемое значение: СписокЗначений.
//
Функция УзлыРИБ(ФильтрПоНазначению = "") Экспорт
	ФильтрПоНазначению = ВРег(ФильтрПоНазначению);

	СписокУзлов		= Новый СписокЗначений;

	ПланыОбменаРИБ	= ПланыОбменаРИБ();
	Запрос			= Новый Запрос;
	Для Каждого ИмяПланаОбмена Из ПланыОбменаРИБ Цикл
		// Зарезервировано для новых подсистем

		Запрос.Текст = "ВЫБРАТЬ
		               |	ПланОбмена.Ссылка КАК Ссылка
		               |ИЗ
		               |	ПланОбмена.[ИмяПланаОбмена] КАК ПланОбмена
		               |ГДЕ
		               |	НЕ ПланОбмена.ЭтотУзел
		               |	И НЕ ПланОбмена.ПометкаУдаления";
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "[ИмяПланаОбмена]", ИмяПланаОбмена);
		ВыборкаУзлов = Запрос.Выполнить().Выбрать();
		Пока ВыборкаУзлов.Следующий() Цикл
			СписокУзлов.Добавить(ВыборкаУзлов.Ссылка);
		КонецЦикла;
	КонецЦикла;

	Возврат СписокУзлов;
КонецФункции

// Возвращает соответствие имен предопределенных значений ссылкам на них.
//
// Параметры:
//  ПолноеИмяОбъектаМетаданных - Строка, например, "Справочник.ВидыНоменклатуры",
//                               Поддерживаются только таблицы
//                               с предопределенными элементами:
//                               - Справочники,
//                               - Планы видов характеристик,
//                               - Планы счетов,
//                               - Планы видов расчета.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие, Неопределено, где
//      * Ключ     - Строка - имя предопределенного,
//      * Значение - Ссылка, Null - ссылка предопределенного или Null, если объекта нет в ИБ.
//
//  Если ошибка в имени метаданных или неподходящий тип метаданного, то возвращается Неопределено.
//  Если предопределенных у метаданного нет, то возвращается пустое фиксированное соответствие.
//  Если предопределенный определен в метаданных, но не создан в ИБ, то для него в соответствии возвращается Null.
//
Функция СсылкиПоИменамПредопределенных(ПолноеИмяОбъектаМетаданных) Экспорт
	ПредопределенныеЗначения = Новый Соответствие;

	МетаданныеОбъекта = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);

	// Если метаданных не существует.
	Если МетаданныеОбъекта = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	// Если не подходящий тип метаданных.
	Если Не Метаданные.Справочники.Содержит(МетаданныеОбъекта)
		И Не Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеОбъекта)
		И Не Метаданные.ПланыСчетов.Содержит(МетаданныеОбъекта)
		И Не Метаданные.ПланыВидовРасчета.Содержит(МетаданныеОбъекта) Тогда

		Возврат Неопределено;
	КонецЕсли;

	ИменаПредопределенных = МетаданныеОбъекта.ПолучитьИменаПредопределенных();

	// Если предопределенных у метаданного нет.
	Если ИменаПредопределенных.Количество() = 0 Тогда
		Возврат Новый ФиксированноеСоответствие(ПредопределенныеЗначения);
	КонецЕсли;

	// Заполнение по умолчанию признаком отсутствия в ИБ (присутствующие переопределятся).
	Для каждого ИмяПредопределенного Из ИменаПредопределенных Цикл
		ПредопределенныеЗначения.Вставить(ИмяПредопределенного, Null);
	КонецЦикла;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	ТекущаяТаблица.Ссылка КАК Ссылка,
	            	  |	ТекущаяТаблица.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных
	            	  |ИЗ
	            	  |	&ТекущаяТаблица КАК ТекущаяТаблица
	            	  |ГДЕ
	            	  |	ТекущаяТаблица.Предопределенный";
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекущаяТаблица", ПолноеИмяОбъектаМетаданных);

	// Разрешение вызова из безопасного режима внешней обработки или расширения.
	// Ссылки предопределенных не являются секретной информацией, потому к ним
	// не следует применять ограничение на уровне записей, к тому же при отсутствии
	// прав разыменование ссылки все равно провалится.

	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);

	Выборка = Запрос.Выполнить().Выбрать();

	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);

	// Заполнение присутствующих в ИБ.
	Пока Выборка.Следующий() Цикл
		ПредопределенныеЗначения.Вставить(Выборка.ИмяПредопределенныхДанных, Выборка.Ссылка);
	КонецЦикла;

	Возврат Новый ФиксированноеСоответствие(ПредопределенныеЗначения);
КонецФункции

#Область ОбщегоНазначения

// Доступность объектов метаданных по функциональным опциям.
Функция ДоступностьОбъектовПоОпциям() Экспорт
	Параметры = Новый ФиксированнаяСтруктура(Новый Структура);
	Параметры = Новый Структура(Параметры);

	ДоступностьОбъектов = Новый Соответствие;
	Для Каждого ФункциональнаяОпция Из Метаданные.ФункциональныеОпции Цикл
		Значение = -1;
		Для Каждого Элемент Из ФункциональнаяОпция.Состав Цикл
			Если Элемент.Объект = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если Значение = -1 Тогда
				Значение = ПолучитьФункциональнуюОпцию(ФункциональнаяОпция.Имя, Параметры);
			КонецЕсли;
			ПолноеИмя = Элемент.Объект.ПолноеИмя();
			Если Значение = Истина Тогда
				ДоступностьОбъектов.Вставить(ПолноеИмя, Истина);
			Иначе
				Если ДоступностьОбъектов[ПолноеИмя] = Неопределено Тогда
					ДоступностьОбъектов.Вставить(ПолноеИмя, Ложь);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Возврат Новый ФиксированноеСоответствие(ДоступностьОбъектов);
КонецФункции

#КонецОбласти
