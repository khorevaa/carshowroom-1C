﻿#Область ОбновлениеИнформационнойБазы

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
//
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииСервер.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	Описание.Имя										= "СтандартныеПодсистемы";
	Описание.Версия										= "2.4.1.80";
	Описание.РежимВыполненияОтложенныхОбработчиков		= "Параллельно";
	Описание.ПараллельноеОтложенноеОбновлениеСВерсии	= "2.3.3.0";
КонецПроцедуры

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//
// Пример:
//  Для добавления своей процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Оперативно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	// Зарезервировано для новых подсистем

	#Область ВариантыОтчетов

	Обработчик							= Обработчики.Добавить();
	Обработчик.УправлениеОбработчиками	= Истина;
	Обработчик.ОбщиеДанные				= Истина;
	Обработчик.РежимВыполнения			= "Оперативно";
	Обработчик.Версия					= "*";
	Обработчик.Процедура				= "ВариантыОтчетовСервер.ОперативноеОбновлениеОбщихДанныхКонфигурации";
	Обработчик.Приоритет				= 90;

	Обработчик								= Обработчики.Добавить();
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.ОбщиеДанные					= Ложь;
	Обработчик.РежимВыполнения				= "Монопольно";
	Обработчик.Версия						= "2.1.3.6";
	Обработчик.Приоритет					= 80;
	Обработчик.Процедура					= "ВариантыОтчетовСервер.ЗаполнитьСсылкиПредопределенных";

	Обработчик								= Обработчики.Добавить();
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.ОбщиеДанные					= Ложь;
	Обработчик.РежимВыполнения				= "Оперативно";
	Обработчик.Версия						= "*";
	Обработчик.Приоритет					= 70;
	Обработчик.Процедура					= "ВариантыОтчетовСервер.ОперативноеОбновлениеРазделенныхДанныхКонфигурации";

	Обработчик					= Обработчики.Добавить();
	Обработчик.РежимВыполнения	= "Отложенно";
	Обработчик.Идентификатор	= Новый УникальныйИдентификатор("814d41ec-82e2-4d25-9334-8335e589fc1f");
	Обработчик.ОбщиеДанные		= Ложь;
	Обработчик.Версия			= "2.2.3.31";
	Обработчик.Процедура		= "ВариантыОтчетовСервер.СократитьКоличествоБыстрыхНастроек";
	Обработчик.Комментарий		= "Уменьшает количество быстрых настроек в пользовательских отчетах до 2 шт.";

	Обработчик					= Обработчики.Добавить();
	Обработчик.РежимВыполнения	= "Отложенно";
	Обработчик.ОбщиеДанные		= Ложь;
	Обработчик.Идентификатор	= Новый УникальныйИдентификатор("38d2a135-53e0-4c68-9bd6-3d6df9b9dcfb");
	Обработчик.Версия			= "*";
	Обработчик.Процедура		= "ВариантыОтчетовСервер.ОтложенноеОбновлениеОбщихДанныхКонфигурацииПолное";
	Обработчик.Комментарий		= "Обновление индекса поиска отчетов, предусмотренных в программе.";

	Обработчик					= Обработчики.Добавить();
	Обработчик.РежимВыполнения	= "Отложенно";
	Обработчик.ОбщиеДанные		= Ложь;
	Обработчик.Идентификатор	= Новый УникальныйИдентификатор("5ba93197-230b-4ac8-9abb-ab3662e5ff76");
	Обработчик.Версия			= "*";
	Обработчик.Процедура		= "ВариантыОтчетовСервер.ОтложенноеОбновлениеРазделенныхДанныхКонфигурацииПолное";
	Обработчик.Комментарий		= "Обновление индекса поиска отчетов, сохраненных пользователями.";

	#КонецОбласти

	// Зарезервировано для новых подсистем

	#Область ОбновлениеИБ

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "2.1.3.4";
	Обработчик.Процедура	= "ОбновлениеИБСервер.УстановитьВерсиюОписанийИзменений";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "2.2.2.7";
	Обработчик.Процедура	= "ОбновлениеИБСервер.ЗаполнитьРеквизитЭтоОсновнаяКонфигурация";
	Обработчик.ОбщиеДанные	= Истина;

	#КонецОбласти

	// Зарезервировано для новых подсистем

	#Область Пользователи

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "1.0.5.2";
	Обработчик.Процедура	= "ПользователиСервер.ЗаполнитьИдентификаторыПользователей";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "1.0.5.15";
	Обработчик.Процедура	= "РегистрыСведений.СоставыГруппПользователей.ОбновитьДанныеРегистра";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "1.0.6.5";
	Обработчик.Процедура	= "РегистрыСведений.СоставыГруппПользователей.ОбновитьДанныеРегистра";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "1.1.1.2";
	Обработчик.Процедура	= "ПользователиСервер.ПриНаличииГруппПользователейУстановитьИспользование";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "2.1.2.8";
	Обработчик.Процедура	= "РегистрыСведений.СоставыГруппПользователей.ОбновитьДанныеРегистра";

	Обработчик						= Обработчики.Добавить();
	Обработчик.Версия				= "2.1.3.16";
	Обработчик.НачальноеЗаполнение	= Истина;
	Обработчик.Процедура			= "ПользователиСервер.ОбновитьПредопределенныеВидыКонтактнойИнформацииПользователей";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "2.1.4.19";
	Обработчик.Процедура	= "ПользователиСервер.ПеренестиГруппыВнешнихПользователейВКорень";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "2.2.2.3";
	Обработчик.Процедура	= "ПользователиСервер.ЗаполнитьСвойстваАутентификацииПользователей";

	Обработчик				= Обработчики.Добавить();
	Обработчик.Версия		= "2.2.2.42";
	Обработчик.Процедура	= "ПользователиСервер.ДобавитьПолноправнымПользователямРольАдминистраторСистемы";

	Обработчик						= Обработчики.Добавить();
	Обработчик.Версия				= "2.3.1.16";
	Обработчик.РежимВыполнения		= "Оперативно";
	Обработчик.Процедура			= "ПользователиСервер.ОчиститьРеквизитПоказыватьВСпискеВыбораУВсехПользователейИБ";

	Обработчик						= Обработчики.Добавить();
	Обработчик.Версия				= "2.3.1.37";
	Обработчик.НачальноеЗаполнение	= Истина;
	Обработчик.РежимВыполнения		= "Оперативно";
	Обработчик.Процедура			= "ПользователиСервер.ЗаполнитьНазначениеГруппВнешнихПользователей";

	Обработчик						= Обработчики.Добавить();
	Обработчик.Версия				= "2.3.2.30";
	Обработчик.НачальноеЗаполнение	= Истина;
	Обработчик.РежимВыполнения		= "Оперативно";
	Обработчик.Процедура			= "ПользователиСервер.ПеренестиНастройкиДлиныИСложностиПаролейКонфигуратора";

	Обработчик								= Обработчики.Добавить();
	Обработчик.Версия						= "2.4.1.1";
	Обработчик.РежимВыполнения				= "Оперативно";
	Обработчик.Процедура					= "ПользователиСервер.ПереименоватьКлючХраненияРешенияПоОткрытиюВнешнихОтчетовИОбработок";
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет					= 1;

	#КонецОбласти

	// Зарезервировано для новых подсистем

	#Область БазоваяПодсистема

	Обработчик					= Обработчики.Добавить();
	Обработчик.Версия			= "*";
	Обработчик.Процедура		= "БазоваяПодсистемаСервер.ПометитьЗаписиКэшаВерсийНеактуальными";
	Обработчик.Приоритет		= 99;
	Обработчик.ОбщиеДанные		= Истина;
	Обработчик.МонопольныйРежим = Ложь;

	Обработчик					= Обработчики.Добавить();
	Обработчик.Версия			= "2.2.2.10";
	Обработчик.ОбщиеДанные		= Истина;
	Обработчик.Процедура		= "БазоваяПодсистемаСервер.ОбновитьПараметрыАдминистрированияИнформационнойБазы";

	Обработчик					= Обработчики.Добавить();
	Обработчик.Версия			= "2.2.4.17";
	Обработчик.ОбщиеДанные		= Истина;
	Обработчик.Процедура		= "БазоваяПодсистемаСервер.УстановитьЗначениеКонстантыГлавныйУзел";

	Обработчик					= Обработчики.Добавить();
	Обработчик.Версия			= "2.3.1.18";
	Обработчик.ОбщиеДанные		= Истина;
	Обработчик.Процедура		= "БазоваяПодсистемаСервер.ПеренестиПаролиВБезопасноеХранилищеОбщиеДанные";

	Обработчик					= Обработчики.Добавить();
	Обработчик.Версия			= "2.3.1.18";
	Обработчик.ОбщиеДанные		= Ложь;
	Обработчик.Процедура		= "БазоваяПодсистемаСервер.ПеренестиПаролиВБезопасноеХранилище";

	#КонецОбласти

	// Зарезервировано для новых подсистем

КонецПроцедуры

Процедура ПередОбновлениемИнформационнойБазы() Экспорт

КонецПроцедуры

Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия, Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт

	// Зарезервировано для новых подсистем

КонецПроцедуры

Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт

КонецПроцедуры

#КонецОбласти

Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	// ТолькоДляАдминистраторовСистемы.
	НазначениеРолей.ТолькоДляАдминистраторовСистемы.Добавить(Метаданные.Роли.АдминистраторСистемы.Имя);

	// ТолькоДляПользователейСистемы.
	НазначениеРолей.ТолькоДляПользователейСистемы.Добавить(Метаданные.Роли.БазовыеПрава.Имя);

	НазначениеРолей.ТолькоДляПользователейСистемы.Добавить(Метаданные.Роли.ИнтерактивноеОткрытиеВнешнихОтчетовИОбработок.Имя);

	// ТолькоДляВнешнихПользователей.
	НазначениеРолей.ТолькоДляВнешнихПользователей.Добавить(Метаданные.Роли.БазовыеПраваВнешнегоПользователя.Имя);

	// СовместноДляПользователейИВнешнихПользователей.
КонецПроцедуры

Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	Обработчики.Вставить("ВыполняетсяОбновлениеИБ",			"ОбновлениеИБСервер.УстановкаПараметровСеанса");
	Обработчики.Вставить("ПараметрыОбработчикаОбновления",	"ОбновлениеИБСервер.УстановкаПараметровСеанса");

	// зарезервировано для новых подсистем

	Обработчики.Вставить("ТекущийПользователь",				"ПользователиСервер.УстановкаПараметровСеанса");
	Обработчики.Вставить("ТекущийВнешнийПользователь",		"ПользователиСервер.УстановкаПараметровСеанса");
	Обработчики.Вставить("АвторизованныйПользователь",		"ПользователиСервер.УстановкаПараметровСеанса");

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	Параметры.Вставить("ВыполнятьЗамеры", ВариантыОтчетовСервер.ВыполнятьЗамеры);
	Если Параметры.ВыполнятьЗамеры Тогда
		УстановитьПривилегированныйРежим(Истина);
		Параметры.Вставить("ПрефиксЗамеров", СтрЗаменить(ПараметрыСеанса["КомментарийЗамераВремени"], ";", "; "));
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;

	// зарезервировано для новых подсистем

	Параметры.Вставить("НачальноеЗаполнениеДанных", ОбновлениеИБСервер.РежимОбновленияДанных() = "НачальноеЗаполнение");
	Параметры.Вставить("ПоказатьОписаниеИзмененийСистемы", ОбновлениеИБСервер.ПоказатьОписаниеИзмененийСистемы());

	СтатусОбработчиков = ОбновлениеИБСервер.СтатусНевыполненныхОбработчиков();
	Если СтатусОбработчиков <> "" Тогда
		Если СтатусОбработчиков = "СтатусОшибка" И ПользователиСервер.ЭтоПолноправныйПользователь(, Истина) Тогда
			Параметры.Вставить("ПоказатьСообщениеОбОшибочныхОбработчиках");
		Иначе
			Параметры.Вставить("ПоказатьОповещениеОНевыполненныхОбработчиках");
		КонецЕсли;
	КонецЕсли;

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	// зарезервировано для новых подсистем

	Параметры.Вставить("ЭтоПолноправныйПользователь", ПользователиСервер.ЭтоПолноправныйПользователь());

	// зарезервировано для новых подсистем

	БазоваяПодсистемаСервер.ДобавитьПараметрыРаботыКлиента(Параметры);

	// зарезервировано для новых подсистем
КонецПроцедуры

// Доопределяет действия при создании администратора в подсистеме Пользователи.
//
// Параметры:
//  Администратор - СправочникСсылка.Пользователи (изменение объекта запрещено).
//  Уточнение     - Строка - поясняет при каких условиях был создан администратор.
//
Процедура ПриСозданииАдминистратора(Администратор, Уточнение) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеЗаписиАдминистратораПриАвторизации(Комментарий) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОпределенииНастроек(Настройки) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеОбновленияСоставовГруппПользователей(УчастникиИзменений, ИзмененныеГруппы) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый) Экспорт
// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриЗаполненииВсехПараметровРаботыРасширений() Экспорт
	// зарезервировано для новых подсистем

	ВариантыОтчетовСервер.ПриЗаполненииВсехПараметровРаботыРасширений();
КонецПроцедуры

Процедура ПриОчисткеВсехПараметровРаботыРасширений() Экспорт
	НаборЗаписей = РегистрыСведений.ПредопределенныеВариантыОтчетовВерсийРасширений.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ВерсияРасширений.Установить(ПараметрыСеанса.ВерсияРасширений);
	НаборЗаписей.Записать();
КонецПроцедуры

Процедура ПриОпределенииДействийВФорме(Ссылка, ДействияВФорме) Экспорт
	// зарезервировано для новых подсистем
КонецПроцедуры

// Позволяет переопределить текст вопроса перед записью первого администратора.
//  Вызывается из обработчика ПередЗаписью формы пользователя.
//  Вызов выполняется если установлен ЗапретРедактированияРолей() и
// количество пользователей информационной базы равно нулю.
//
// Параметры:
//  ТекстВопроса - Строка - текст вопроса, который можно переопределить.
//
Процедура ПриОпределенииТекстаВопросаПередЗаписьюПервогоАдминистратора(ТекстВопроса) Экспорт
	 // зарезервировано для новых подсистем
КонецПроцедуры

// Доопределяет действия, необходимые после установки пользователя
// информационной базы у пользователя или внешнего пользователя,
// т.е. при изменении реквизита ИдентификаторПользователяИБ на не пустой.
//
// Например, можно обновить роли.
//
// Параметры:
//  Ссылка - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - пользователь.
//
Процедура ПослеУстановкиПользователяИБ(Ссылка) Экспорт
	// зарезервировано для новых подсистем
КонецПроцедуры

// Доопределяет действия, необходимые после изменении объекта авторизации внешнего пользователя.
//
// Параметры:
//  ВнешнийПользователь     - СправочникСсылка.ВнешниеПользователи - внешний пользователь.
//  СтарыйОбъектАвторизации - NULL - при добавлении внешнего пользователя.
//                          - ОпределяемыйТип.ВнешнийПользователь - тип объекта авторизации.
//  НовыйОбъектАвторизации  - ОпределяемыйТип.ВнешнийПользователь - тип объекта авторизации.
//
Процедура ПослеИзмененияОбъектаАвторизацииВнешнегоПользователя(ВнешнийПользователь, СтарыйОбъектАвторизации, НовыйОбъектАвторизации) Экспорт
	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеПолученияДанных(Отправитель, Отказ, ПолучениеИзГлавногоУзла) Экспорт
	ПользователиСервер.сОбновитьРолиВнешнихПользователей();

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОтправкеДанныхГлавному(ЭлементДанных, ОтправкаЭлемента, Получатель) Экспорт
	// зарезервировано для новых подсистем

	ОбновлениеИБСервер.ПриОтправкеВерсийПодсистем(ЭлементДанных, ОтправкаЭлемента);
	ПользователиСервер.сПриОтправкеДанных(ЭлементДанных, ОтправкаЭлемента, Ложь);

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОтправкеДанныхПодчиненному(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза, Получатель) Экспорт
	// зарезервировано для новых подсистем

	ОбновлениеИБСервер.ПриОтправкеВерсийПодсистем(ЭлементДанных, ОтправкаЭлемента, СозданиеНачальногоОбраза);
	ПользователиСервер.сПриОтправкеДанных(ЭлементДанных, ОтправкаЭлемента, Истина);

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриПолученииДанныхОтГлавного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Отправитель) Экспорт
	// зарезервировано для новых подсистем

	ПользователиСервер.сПриПолученииДанных(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Ложь);

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриПолученииДанныхОтПодчиненного(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Отправитель) Экспорт
	// зарезервировано для новых подсистем

	ПользователиСервер.сПриПолученииДанных(ЭлементДанных, ПолучениеЭлемента, ОтправкаНазад, Истина);

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриНастройкеВариантовОтчетов(Настройки) Экспорт
	// зарезервировано для новых подсистем

	НастройкиОтчета = ВариантыОтчетовСервер.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ПрогрессОтложенногоОбновления);
	Метаданные.Отчеты.ПрогрессОтложенногоОбновления.НастроитьВариантыОтчета(Настройки, НастройкиОтчета);

	// зарезервировано для новых подсистем

	НастройкиОтчета = ВариантыОтчетовСервер.ОписаниеОтчета(Настройки, Метаданные.Отчеты.СведенияОПользователях);
	Метаданные.Отчеты.СведенияОПользователях.НастроитьВариантыОтчета(Настройки, НастройкиОтчета);

	// зарезервировано для новых подсистем
КонецПроцедуры
