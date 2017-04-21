﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем СтарыйРодитель; // Значение родителя группы до изменения для использования
                      // в обработчике события ПриЗаписи.

Перем СтарыйСоставГруппыВнешнихПользователей; // Состав внешних пользователей группы внешних
                                              // пользователей до изменения для использования
                                              // в обработчике события ПриЗаписи.

Перем СтарыйСоставРолейГруппыВнешнихПользователей; // Состав ролей группы внешних пользователей
                                                   // до изменения для использования в обработчике
                                                   // события ПриЗаписи.

Перем СтароеЗначениеВсеОбъектыАвторизации; // Значение реквизита ВсеОбъектыАвторизации
                                           // до изменения для использования в обработчике
                                           // события ПриЗаписи.

Перем ЭтоНовый; // Показывает, что был записан новый объект.
                // Используются в обработчике события ПриЗаписи.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ДополнительныеСвойства.Свойство("ПроверенныеРеквизитыОбъекта") Тогда
		ПроверенныеРеквизитыОбъекта = ДополнительныеСвойства.ПроверенныеРеквизитыОбъекта;
	Иначе
		ПроверенныеРеквизитыОбъекта = Новый Массив;
	КонецЕсли;

	Ошибки = Неопределено;

	// Проверка использования родителя.
	ТекстОшибки = ТекстОшибкиПроверкиРодителя();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		БазоваяПодсистемаКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Родитель", ТекстОшибки, "");
	КонецЕсли;

	// Проверка незаполненных и повторяющихся внешних пользователей.
	ПроверенныеРеквизитыОбъекта.Добавить("Состав.ВнешнийПользователь");

	// Проверка назначения группы.
	ТекстОшибки = ТекстОшибкиПроверкиНазначения();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		БазоваяПодсистемаКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Назначение", ТекстОшибки, "");
	КонецЕсли;
	ПроверенныеРеквизитыОбъекта.Добавить("Назначение");

	Для каждого ТекущаяСтрока Из Состав Цикл
		НомерСтроки = Состав.Индекс(ТекущаяСтрока);

		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ВнешнийПользователь) Тогда
			БазоваяПодсистемаКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				"Внешний пользователь не выбран.",
				"Объект.Состав",
				НомерСтроки,
				"Внешний пользователь в строке %1 не выбран.");
			Продолжить;
		КонецЕсли;

		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Состав.НайтиСтроки(Новый Структура("ВнешнийПользователь", ТекущаяСтрока.ВнешнийПользователь));
		Если НайденныеЗначения.Количество() > 1 Тогда
			БазоваяПодсистемаКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
				"Объект.Состав[%1].ВнешнийПользователь",
				"Внешний пользователь повторяется.",
				"Объект.Состав",
				НомерСтроки,
				"Внешний пользователь в строке %1 повторяется.");
		КонецЕсли;
	КонецЦикла;

	БазоваяПодсистемаКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);

	БазоваяПодсистемаСервер.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ПроверенныеРеквизитыОбъекта);
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПользователиСерверПовтИсп.Настройки().РедактированиеРолей Тогда
		РезультатЗапроса = БазоваяПодсистемаСервер.ЗначениеРеквизитаОбъекта(Ссылка, "Роли");
		Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
			СтарыйСоставРолейГруппыВнешнихПользователей = РезультатЗапроса.Выгрузить();
		Иначе
			СтарыйСоставРолейГруппыВнешнихПользователей = Роли.Выгрузить(Новый Массив);
		КонецЕсли;
	КонецЕсли;

	ЭтоНовый = ЭтоНовый();

	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Назначение.Очистить();

		ОписаниеТипаСсылки				= Новый ОписаниеТипов(БазоваяПодсистемаКлиентСервер.ЗначениеВМассиве("Строка"));
		Значение						= ОписаниеТипаСсылки.ПривестиЗначение(Неопределено);

		НоваяСтрока						= Назначение.Добавить();
		НоваяСтрока.ТипПользователей	= Значение;

		ВсеОбъектыАвторизации			= Ложь;
	КонецЕсли;

	ТекстОшибки = ТекстОшибкиПроверкиРодителя();
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Если Состав.Количество() > 0 Тогда
			ВызватьИсключение "Добавление участников в предопределенную группу ""Все внешние пользователи"" запрещено.";
		КонецЕсли;
	Иначе
		ТекстОшибки = ТекстОшибкиПроверкиНазначения();
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;

		СтарыеЗначения = БазоваяПодсистемаСервер.ЗначенияРеквизитовОбъекта(Ссылка, "ВсеОбъектыАвторизации, Родитель");

		СтарыйРодитель                      = СтарыеЗначения.Родитель;
		СтароеЗначениеВсеОбъектыАвторизации = СтарыеЗначения.ВсеОбъектыАвторизации;

		Если ЗначениеЗаполнено(Ссылка) И Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			РезультатЗапроса = БазоваяПодсистемаСервер.ЗначениеРеквизитаОбъекта(Ссылка, "Состав");
			Если ТипЗнч(РезультатЗапроса) = Тип("РезультатЗапроса") Тогда
				СтарыйСоставГруппыВнешнихПользователей = РезультатЗапроса.Выгрузить();
			Иначе
				СтарыйСоставГруппыВнешнихПользователей = Состав.Выгрузить(Новый Массив);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ПользователиСерверПовтИсп.Настройки().РедактированиеРолей <> Истина Тогда
		ИзменилсяСоставРолейГруппыВнешнихПользователей = Ложь;
	Иначе
		ИзменилсяСоставРолейГруппыВнешнихПользователей = ПользователиСервер.РазличияЗначенийКолонки(
				"Роль",
				Роли.Выгрузить(),
				СтарыйСоставРолейГруппыВнешнихПользователей).Количество() <> 0;
	КонецЕсли;

	УчастникиИзменений = Новый Соответствие;
	ИзмененныеГруппы   = Новый Соответствие;

	Если Ссылка <> Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Если ВсеОбъектыАвторизации ИЛИ СтароеЗначениеВсеОбъектыАвторизации = Истина Тогда
			ПользователиСервер.ОбновитьСоставыГруппВнешнихПользователей(Ссылка, , УчастникиИзменений, ИзмененныеГруппы);
		Иначе
			ИзмененияСостава = ПользователиСервер.РазличияЗначенийКолонки(
				"ВнешнийПользователь",
				Состав.Выгрузить(),
				СтарыйСоставГруппыВнешнихПользователей);

			ПользователиСервер.ОбновитьСоставыГруппВнешнихПользователей(Ссылка, ИзмененияСостава, УчастникиИзменений, ИзмененныеГруппы);

			Если СтарыйРодитель <> Родитель Тогда
				Если ЗначениеЗаполнено(Родитель) Тогда
					ПользователиСервер.ОбновитьСоставыГруппВнешнихПользователей(Родитель, , УчастникиИзменений, ИзмененныеГруппы);
				КонецЕсли;

				Если ЗначениеЗаполнено(СтарыйРодитель) Тогда
					ПользователиСервер.ОбновитьСоставыГруппВнешнихПользователей(СтарыйРодитель, , УчастникиИзменений, ИзмененныеГруппы);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		ПользователиСервер.ОбновитьИспользуемостьСоставовГруппПользователей(Ссылка, УчастникиИзменений, ИзмененныеГруппы);
	КонецЕсли;

	Если ИзменилсяСоставРолейГруппыВнешнихПользователей Тогда
		ПользователиСервер.ОбновитьРолиВнешнихПользователей(Ссылка);
	КонецЕсли;

	ПользователиСервер.ПослеОбновленияСоставовГруппВнешнихПользователей(УчастникиИзменений, ИзмененныеГруппы);

	ИнтеграцияПодсистемСервер.ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый);
КонецПроцедуры

#КонецОбласти

Функция ТекстОшибкиПроверкиРодителя()
	Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Возврат "Предопределенная группа ""Все внешние пользователи"" не может быть родителем.";
	КонецЕсли;

	Если Ссылка = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
		Если Не Родитель.Пустая() Тогда
			Возврат "Предопределенная группа ""Все внешние пользователи"" не может быть перемещена.";
		КонецЕсли;
	Иначе
		Если Родитель = Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи Тогда
			Возврат "Невозможно добавить подгруппу к предопределенной группе ""Все внешние пользователи"".";
		ИначеЕсли Родитель.ВсеОбъектыАвторизации Тогда
			Возврат СтрШаблон("Невозможно добавить подгруппу к группе ""%1"",
				           |так как в число ее участников входят все пользователи.", Родитель);
		КонецЕсли;

		Если ВсеОбъектыАвторизации И ЗначениеЗаполнено(Родитель) Тогда
			Возврат "Невозможно переместить группу, в число участников которой входят все пользователи.";
		КонецЕсли;
	КонецЕсли;

	Возврат "";
КонецФункции

Функция ТекстОшибкиПроверкиНазначения()
	// Проверка заполнения назначения группы.
	Если Назначение.Количество() = 0 Тогда
		Возврат "Не указан вид участников группы.";
	КонецЕсли;

	// Проверка уникальности группы всех объектов авторизации заданного типа.
	Если ВсеОбъектыАвторизации Тогда
		// Проверка что назначение не совпадает с группой все внешние пользователи.
		ГруппаВсеВнешниеПользователи		= Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи;
		НазначениеВсеВнешниеПользователи	= БазоваяПодсистемаСервер.ЗначениеРеквизитаОбъекта(ГруппаВсеВнешниеПользователи, "Назначение").Выгрузить().ВыгрузитьКолонку("ТипПользователей");
		МассивНазначения					= Назначение.ВыгрузитьКолонку("ТипПользователей");

		Если БазоваяПодсистемаКлиентСервер.СпискиЗначенийИдентичны(НазначениеВсеВнешниеПользователи, МассивНазначения) Тогда
			Возврат "Невозможно создать группу, совпадающую по назначению
				           |с предопределенной группой ""Все внешние пользователи"".";
		КонецЕсли;

		Запрос			= Новый Запрос;
		Запрос.Текст	= "ВЫБРАТЬ
		            	  |	ТипыПользователей.ТипПользователей КАК ТипПользователей
		            	  |ПОМЕСТИТЬ ТипыПользователей
		            	  |ИЗ
		            	  |	&ТипыПользователей КАК ТипыПользователей
		            	  |;
		            	  |
		            	  |////////////////////////////////////////////////////////////////////////////////
		            	  |ВЫБРАТЬ
		            	  |	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
		            	  |ИЗ
		            	  |	Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователей
		            	  |ГДЕ
		            	  |	ИСТИНА В
		            	  |			(ВЫБРАТЬ ПЕРВЫЕ 1
		            	  |				ИСТИНА
		            	  |			ИЗ
		            	  |				ТипыПользователей КАК ТипыПользователей
		            	  |			ГДЕ
		            	  |				ГруппыВнешнихПользователей.Ссылка <> &Ссылка
		            	  |				И ГруппыВнешнихПользователей.Ссылка.ВсеОбъектыАвторизации
		            	  |				И ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей) = ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователей.ТипПользователей))";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ТипыПользователей", Назначение.Выгрузить());

		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();

			Возврат СтрШаблон("Уже существует группа ""%1"",
				           |в число участников которой входят все пользователи указанных видов.",
				Выборка.СсылкаПредставление);
		КонецЕсли;
	КонецЕсли;

	// Проверка совпадения типа объектов авторизации с родителем
	// (допустимо, если тип у родителя не задан).
	Если ЗначениеЗаполнено(Родитель) Тогда
		ТипПользователейРодителя	= БазоваяПодсистемаСервер.ЗначениеРеквизитаОбъекта(Родитель, "Назначение").Выгрузить().ВыгрузитьКолонку("ТипПользователей");
		ТипПользователей			= Назначение.ВыгрузитьКолонку("ТипПользователей");

		Для Каждого ТипПользователя Из ТипПользователей Цикл
			Если ТипПользователейРодителя.Найти(ТипПользователя) = Неопределено Тогда
				Возврат СтрШаблон("Вид участников группы должен быть как у вышестоящей
					           |группы внешних пользователей ""%1"".", Родитель);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Если группе внешних пользователей устанавливается тип участников "Все пользователи заданного типа",
	// проверяем наличие подчиненных групп.
	Если ВсеОбъектыАвторизации И ЗначениеЗаполнено(Ссылка) Тогда
		Запрос			= Новый Запрос;
		Запрос.Текст	= "ВЫБРАТЬ
		            	  |	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователей.Ссылка) КАК СсылкаПредставление
		            	  |ИЗ
		            	  |	Справочник.ГруппыВнешнихПользователей КАК ГруппыВнешнихПользователей
		            	  |ГДЕ
		            	  |	ГруппыВнешнихПользователей.Родитель = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);

		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Возврат "Невозможно изменить вид участников группы,
				           |так как у нее имеются подгруппы.";
		КонецЕсли;
	КонецЕсли;

	// Проверка, что при изменении типа объектов авторизации
	// нет подчиненных элементов другого типа (очистка типа допустима).
	Если ЗначениеЗаполнено(Ссылка) Тогда
		Запрос			= Новый Запрос;
		Запрос.Текст	= "ВЫБРАТЬ
		            	  |	ТипыПользователей.ТипПользователей КАК ТипПользователей
		            	  |ПОМЕСТИТЬ ТипыПользователей
		            	  |ИЗ
		            	  |	&ТипыПользователей КАК ТипыПользователей
		            	  |;
		            	  |
		            	  |////////////////////////////////////////////////////////////////////////////////
		            	  |ВЫБРАТЬ
		            	  |	ПРЕДСТАВЛЕНИЕ(ГруппыВнешнихПользователейНазначение.Ссылка) КАК СсылкаПредставление
		            	  |ИЗ
		            	  |	Справочник.ГруппыВнешнихПользователей.Назначение КАК ГруппыВнешнихПользователейНазначение
		            	  |ГДЕ
		            	  |	ИСТИНА В
		            	  |			(ВЫБРАТЬ ПЕРВЫЕ 1
		            	  |				ИСТИНА
		            	  |			ИЗ
		            	  |				ТипыПользователей КАК ТипыПользователей
		            	  |			ГДЕ
		            	  |				ГруппыВнешнихПользователейНазначение.Ссылка.Родитель = &Ссылка
		            	  |				И ТИПЗНАЧЕНИЯ(ГруппыВнешнихПользователейНазначение.ТипПользователей) <> ТИПЗНАЧЕНИЯ(ТипыПользователей.ТипПользователей))";
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("ТипыПользователей", Назначение);

		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();

			Возврат СтрШаблон("Невозможно изменить вид участников группы,
				           |так как у нее имеется подгруппа ""%1"" с другим назначением участников.",
				Выборка.СсылкаПредставление);
		КонецЕсли;
	КонецЕсли;

	Возврат "";
КонецФункции

#КонецЕсли