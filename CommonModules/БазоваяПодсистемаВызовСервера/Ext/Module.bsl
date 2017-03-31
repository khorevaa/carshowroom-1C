﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая подсистема"
//
////////////////////////////////////////////////////////////////////////////////

// Проверяет право на отключение логики работы системы и
// скрывает рабочий стол на сервере, если право есть,
// в противном случае вызывает исключение.
//
Процедура ПроверитьПравоОтключитьЛогикуНачалаРаботыСистемы() Экспорт
	СкрытьРабочийСтолПриНачалеРаботыСистемы(Истина);

	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда	
		ВызватьИсключение "Недостаточно прав для работы с отключенной логикой работы системы.";
	КонецЕсли;

	ПользователиСервер.ПроверитьПраваТекущегоПользователяПриВходе();	
КонецПроцедуры

// Устанавливает состояние отмены при создании форм рабочего стола.
// Требуется, если при запуске программы возникает необходимость
// взаимодействия с пользователем (интерактивная обработка).
//
// Используется из одноименной процедуры в модуле СтандартныеПодсистемыКлиент.
// Прямой вызов на сервере имеет смысл для сокращения серверных вызовов,
// если при подготовке параметров клиента через модуль ПовтИсп уже
// известно, что интерактивная обработка требуется.
//
// Если прямой вызов сделан из процедуры получения параметров клиент,
// то состояние на клиенте будет обновлено автоматически, в другом случае
// это нужно сделать самостоятельно на клиенте с помощью одноименной процедуры
// в модуле СтандартныеПодсистемыКлиент.
//
// Параметры:
//  Скрыть - Булево - если установить Истина, состояние будет установлено,
//           если установить Ложь, состояние будет снято (после этого
//           можно выполнить метод ОбновитьИнтерфейс и формы рабочего
//           стола будут пересозданы).
//
Процедура СкрытьРабочийСтолПриНачалеРаботыСистемы(Скрыть = Истина) Экспорт
	Если ТекущийРежимЗапуска() = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// Сохранение или восстановление состава форм начальной страницы.
	КлючОбъекта         = "Общее/НастройкиНачальнойСтраницы";
	КлючОбъектаХранения = "Общее/НастройкиНачальнойСтраницыПередОчисткой";
	СохраненныеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъектаХранения, "");
	
	Если ТипЗнч(Скрыть) <> Тип("Булево") Тогда
		Скрыть = ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения");
	КонецЕсли;
	
	Если Скрыть Тогда
		ТекущиеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта);
		Если ТипЗнч(СохраненныеНастройки) <> Тип("ХранилищеЗначения") Тогда
			СохраняемыеНастройки = Новый ХранилищеЗначения(ТекущиеНастройки);
			ХранилищеСистемныхНастроек.Сохранить(КлючОбъектаХранения, "", СохраняемыеНастройки);
		КонецЕсли;
		Если ТипЗнч(ТекущиеНастройки) <> Тип("НастройкиНачальнойСтраницы")
		 Или ТекущиеНастройки.ПолучитьСоставФорм().ПраваяКолонка.Количество() <> 0
		 Или ТекущиеНастройки.ПолучитьСоставФорм().ЛеваяКолонка.Количество() <> 1
		 Или ТекущиеНастройки.ПолучитьСоставФорм().ЛеваяКолонка[0] <> "ОбщаяФорма.ПустойРабочийСтол" Тогда
		
			СоставФорм			= Новый СоставФормНачальнойСтраницы;
			СоставФорм.ЛеваяКолонка.Добавить("ОбщаяФорма.ПустойРабочийСтол");
			ВременныеНастройки	= Новый НастройкиНачальнойСтраницы;
			ВременныеНастройки.УстановитьСоставФорм(СоставФорм);
			ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, "", ВременныеНастройки);
		КонецЕсли;
	Иначе
		Если ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения") Тогда
			СохраненныеНастройки = СохраненныеНастройки.Получить();
			Если СохраненныеНастройки = Неопределено Тогда
				ХранилищеСистемныхНастроек.Удалить(КлючОбъекта, Неопределено, ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
			Иначе
				ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, "", СохраненныеНастройки);
			КонецЕсли;
			ХранилищеСистемныхНастроек.Удалить(КлючОбъектаХранения, Неопределено, ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
		КонецЕсли;
	КонецЕсли;

	ТекущиеПараметры = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);

	Если Скрыть Тогда
		ТекущиеПараметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Истина);
	ИначеЕсли ТекущиеПараметры.Получить("СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено Тогда
		ТекущиеПараметры.Удалить("СкрытьРабочийСтолПриНачалеРаботыСистемы");
	КонецЕсли;

	ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ТекущиеПараметры);
КонецПроцедуры

// Возвращает структуру параметров, необходимых для работы клиентского кода конфигурации
// при запуске, т.е. в обработчиках событий ПередНачаломРаботыСистемы, ПриНачалеРаботыСистемы.
//
Функция ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	НовыеПараметры = Новый Структура;
	ДобавитьПоправкиКВремени(НовыеПараметры, Параметры);

	Параметры.Вставить("ИменаВременныхПараметров", Новый Массив);
	Для каждого КлючИЗначение Из Параметры Цикл
		Параметры.ИменаВременныхПараметров.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;

	БазоваяПодсистемаКлиентСервер.ДополнитьСтруктуру(Параметры, НовыеПараметры);

	ОбработатьПараметрыКлиентаНаСервере(Параметры);

	Если Параметры.ПолученныеПараметрыКлиента <> Неопределено Тогда
		Если НЕ Параметры.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
			// Обновить состояние скрытия рабочего стола, если при предыдущем
			// запуске произошел сбой до момента штатного восстановления.
			СкрытьРабочийСтолПриНачалеРаботыСистемы(Неопределено);
		КонецЕсли;
	КонецЕсли;

	Если НЕ БазоваяПодсистемаСервер.ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		Возврат ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
	КонецЕсли;

	ПользователиСервер.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры, Неопределено, Ложь);

	ИнтеграцияПодсистемСервер.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);

	Возврат ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
КонецФункции

// Возвращает структуру параметров, необходимых для работы клиентского кода конфигурации.
// Только для вызова из БазоваяПодсистемаКлиентПовтИсп.ПараметрыРаботыКлиента.
//
Функция ПараметрыРаботыКлиента(СвойстваКлиента) Экспорт
	Параметры = Новый Структура;
	ДобавитьПоправкиКВремени(Параметры, СвойстваКлиента);

	ИнтеграцияПодсистемСервер.ПриДобавленииПараметровРаботыКлиента(Параметры);

	Возврат БазоваяПодсистемаСервер.ФиксированныеДанные(Параметры);
КонецФункции

Процедура ДобавитьПоправкиКВремени(Параметры, СвойстваКлиента)
	ДатаСеанса				= ТекущаяДатаСеанса();
	ДатаСеансаУниверсальная = УниверсальноеВремя(ДатаСеанса, ЧасовойПоясСеанса());

	Параметры.Вставить("ПоправкаКВремениСеанса", ДатаСеанса - СвойстваКлиента.ТекущаяДатаНаКлиенте);
	Параметры.Вставить("ПоправкаКУниверсальномуВремени", ДатаСеансаУниверсальная - ДатаСеанса);
	Параметры.Вставить("СмещениеСтандартногоВремени", СмещениеСтандартногоВремени(ЧасовойПоясСеанса()));
	Параметры.Вставить("СмещениеДатыКлиента", ТекущаяУниверсальнаяДатаВМиллисекундах() - СвойстваКлиента.ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте);
КонецПроцедуры

Процедура ОбработатьПараметрыКлиентаНаСервере(Знач Параметры)
	ПривилегированныйРежимУстановленПриЗапуске = ПривилегированныйРежим();
	УстановитьПривилегированныйРежим(Истина);

	Если ПараметрыСеанса.ПараметрыКлиентаНаСервере.Количество() = 0 Тогда
		// Первый серверный вызов с клиента при запуске.
		ПараметрыКлиента = Новый Соответствие;
		ПараметрыКлиента.Вставить("ПараметрЗапуска", Параметры.ПараметрЗапуска);
		ПараметрыКлиента.Вставить("СтрокаСоединенияИнформационнойБазы", Параметры.СтрокаСоединенияИнформационнойБазы);
		ПараметрыКлиента.Вставить("ПривилегированныйРежимУстановленПриЗапуске", ПривилегированныйРежимУстановленПриЗапуске);
		ПараметрыКлиента.Вставить("ЭтоВебКлиент", Параметры.ЭтоВебКлиент);
		ПараметрыКлиента.Вставить("ЭтоВебКлиентПодMacOS", Параметры.ЭтоВебКлиентПодMacOS);
		ПараметрыКлиента.Вставить("ЭтоLinuxКлиент", Параметры.ЭтоLinuxКлиент);
		ПараметрыКлиента.Вставить("ЭтоOSXКлиент", Параметры.ЭтоOSXКлиент);
		ПараметрыКлиента.Вставить("ЭтоWindowsКлиент", Параметры.ЭтоWindowsКлиент);
		ПараметрыКлиента.Вставить("ИспользуемыйКлиент", Параметры.ИспользуемыйКлиент);
		ПараметрыКлиента.Вставить("ОперативнаяПамять", Параметры.ОперативнаяПамять);
		ПараметрыКлиента.Вставить("КаталогПрограммы", Параметры.КаталогПрограммы);
		ПараметрыКлиента.Вставить("ИдентификаторКлиента", Параметры.ИдентификаторКлиента);
		ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ПараметрыКлиента);

		Если СтрНайти(НРег(Параметры.ПараметрЗапуска), НРег("ЗапуститьОбновлениеИнформационнойБазы")) > 0 Тогда
			ОбновлениеИБСервер.УстановитьЗапускОбновленияИнформационнойБазы(Истина);
		КонецЕсли;

		Если ПланыОбмена.ГлавныйУзел() <> Неопределено Или ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
			// Предотвращение случайного обновления предопределенных данных в подчиненном узле РИБ:
			// - при запуске с временно отмененным главным узлом;
			// - при реструктуризации данных в процессе восстановления узла.
			Если ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы() <> ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически Тогда
				УстановитьОбновлениеПредопределенныхДанныхИнформационнойБазы(ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически);
			КонецЕсли;
			Если ПланыОбмена.ГлавныйУзел() <> Неопределено И Не ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
				// Сохранение главного узла для возможности восстановления.
				БазоваяПодсистемаСервер.СохранитьГлавныйУзел();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры)
	ПараметрыКлиента	= Параметры;
	Параметры			= Новый Структура;

	Для каждого ИмяВременногоПараметра Из ПараметрыКлиента.ИменаВременныхПараметров Цикл
		Параметры.Вставить(ИмяВременногоПараметра, ПараметрыКлиента[ИмяВременногоПараметра]);
		ПараметрыКлиента.Удалить(ИмяВременногоПараметра);
	КонецЦикла;
	Параметры.Удалить("ИменаВременныхПараметров");

	УстановитьПривилегированныйРежим(Истина);

	Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено;

	УстановитьПривилегированныйРежим(Ложь);

	Возврат БазоваяПодсистемаСервер.ФиксированныеДанные(ПараметрыКлиента);
КонецФункции

Функция ЗаписатьОшибкуВЖурналРегистрацииПриЗапускеИлиЗавершении(ПрекратитьРаботу, Знач Событие, Знач ТекстОшибки) Экспорт
	Если Событие = "Запуск" Тогда
		ИмяСобытия	= "Запуск программы";
		Если ПрекратитьРаботу Тогда
			НачалоОписанияОшибки	= "Возникла исключительная ситуация при запуске программы. Запуск программы аварийно завершен.";
		Иначе
			НачалоОписанияОшибки	= "Возникла исключительная ситуация при запуске программы.";
		КонецЕсли;
	Иначе
		ИмяСобытия	= "Завершение программы";
		НачалоОписанияОшибки		= "Возникла исключительная ситуация при завершении программы.";
	КонецЕсли;

	ОписаниеОшибки = НачалоОписанияОшибки + Символы.ПС + Символы.ПС + ТекстОшибки;
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);

	Возврат НачалоОписанияОшибки;
КонецФункции

// Вызывается из обработчика ожидания каждые 20 минут, например, для контроля
// динамического обновления и окончания срока действия учетной записи пользователя.
//
// Параметры:
//  Параметры - Структура - в структуру следует вставить свойства для дальнейшего анализа на клиенте.
//
Процедура ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры) Экспорт
	Параметры.Вставить("КонфигурацияБазыДанныхИзмененаДинамически", КонфигурацияБазыДанныхИзмененаДинамически() Или Справочники.ВерсииРасширений.РасширенияИзмененыДинамически());

	ПользователиСервер.ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры);

    // зарезервировано для новых подсистем
КонецПроцедуры