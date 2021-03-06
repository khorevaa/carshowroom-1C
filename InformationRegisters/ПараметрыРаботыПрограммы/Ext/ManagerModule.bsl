﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Проверяет требуется ли обновление или настройка информационной базы
// перед началом использования.
//
// Параметры:
//  НастройкаПодчиненногоУзлаРИБ - Булево - (возвращаемое значение), устанавливается Истина,
//                                 если обновление требуется в связи с настройкой подчиненного узла РИБ.
//
// Возвращаемое значение:
//  Булево - возвращает Истина, если требуется обновление или настройка информационной базы.
//
Функция НеобходимоОбновление(НастройкаПодчиненногоУзлаРИБ = Ложь) Экспорт
	// Обновление в локальном режиме.
	Если ОбновлениеИБСерверПовтИсп.НеобходимоОбновлениеИнформационнойБазы() Тогда
		Возврат Истина;
	КонецЕсли;

	// зарезервировано для новых подсистем

	Возврат Ложь;
КонецФункции

Функция ПараметрРаботыПрограммы(ИмяПараметра) Экспорт
	ОписаниеЗначения = ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра);

	Если БазоваяПодсистемаСервер.ВерсияПрограммыОбновленаДинамически() Тогда
		Возврат ОписаниеЗначения.Значение;
	КонецЕсли;

	Если ОписаниеЗначения.Версия <> Метаданные.Версия Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ОписаниеЗначения.Значение;
КонецФункции

Процедура УстановитьПараметрРаботыПрограммы(ИмяПараметра, Значение) Экспорт
	БазоваяПодсистемаСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();

	ОписаниеЗначения = Новый Структура;
	ОписаниеЗначения.Вставить("Версия", Метаданные.Версия);
	ОписаниеЗначения.Вставить("Значение", Значение);

	УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра, ОписаниеЗначения);

КонецПроцедуры

Функция ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра)
	ОписаниеЗначения	= ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра);

	Если ТипЗнч(ОписаниеЗначения) <> Тип("Структура") Или ОписаниеЗначения.Количество() <> 2 Или Не ОписаниеЗначения.Свойство("Версия") Или Не ОписаниеЗначения.Свойство("Значение") Тогда
		Если БазоваяПодсистемаСервер.ВерсияПрограммыОбновленаДинамически() Тогда
			БазоваяПодсистемаСервер.ПотребоватьПерезапускСеансаПоПричинеДинамическогоОбновленияВерсииПрограммы();
		КонецЕсли;

		ОписаниеЗначения	= Новый Структура("Версия, Значение");
	КонецЕсли;

	Возврат ОписаниеЗначения;
КонецФункции

Функция ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра)
	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
	            	  |	ПараметрыРаботыПрограммы.ХранилищеПараметра КАК ХранилищеПараметра
	            	  |ИЗ
	            	  |	РегистрСведений.ПараметрыРаботыПрограммы КАК ПараметрыРаботыПрограммы
	            	  |ГДЕ
	            	  |	ПараметрыРаботыПрограммы.ИмяПараметра = &ИмяПараметра";
	Запрос.УстановитьПараметр("ИмяПараметра", ИмяПараметра);

	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ХранилищеПараметра.Получить();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);

	Возврат Неопределено;
КонецФункции

Процедура УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра, ХранимыеДанные)
	НаборЗаписей	= СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИмяПараметра.Установить(ИмяПараметра);

	НоваяЗапись						= НаборЗаписей.Добавить();
	НоваяЗапись.ИмяПараметра		= ИмяПараметра;
	НоваяЗапись.ХранилищеПараметра	= Новый ХранилищеЗначения(ХранимыеДанные);

	ОбновлениеИБСервер.ЗаписатьНаборЗаписей(НаборЗаписей, , Ложь, Ложь);
КонецПроцедуры

Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы() Экспорт
	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) И Не ВыполнятьОбновлениеБезФоновогоЗадания() Тогда
		// Запуск фонового задания.
		Результат				= ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне(Неопределено, Неопределено, Ложь);
		ОбработанныйРезультат	= ОбработанныйРезультатДлительнойОперации(Результат);

		Если ЗначениеЗаполнено(ОбработанныйРезультат.КраткоеПредставлениеОшибки) Тогда
			ВызватьИсключение ОбработанныйРезультат.ПодробноеПредставлениеОшибки;
		КонецЕсли;
	Иначе
		ЗагрузитьОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(Ложь);
		ОбработатьПараметрыРаботыВерсийРасширений(); // Выше вызывается при обработке результата.
	КонецЕсли;
КонецПроцедуры

Функция ЗагрузитьОбновитьПараметрыРаботыПрограммыВФоне(ОжидатьЗавершение, ИдентификаторФормы, СообщитьПрогресс) Экспорт
	ПараметрыОперации = Новый Структура;
	ПараметрыОперации.Вставить("ИдентификаторФормы",			ИдентификаторФормы);
	ПараметрыОперации.Вставить("ДополнительныйРезультат",		Ложь);
	ПараметрыОперации.Вставить("ОжидатьЗавершение",				?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 4, 2));
	ПараметрыОперации.Вставить("НаименованиеФоновогоЗадания",	"");
	ПараметрыОперации.Вставить("КлючФоновогоЗадания",			"");
	ПараметрыОперации.Вставить("АдресРезультата",				Неопределено);
	ПараметрыОперации.Вставить("ЗапуститьНеВФоне",				Ложь);
	ПараметрыОперации.Вставить("ЗапуститьВФоне",				Ложь);
	ПараметрыОперации.Вставить("БезРасширений",					Ложь);

	ПараметрыОперации.НаименованиеФоновогоЗадания	= "Фоновое обновление параметров работы программы";
	ПараметрыОперации.ОжидатьЗавершение				= ОжидатьЗавершение;
	ПараметрыОперации.БезРасширений					= Истина;

	Если БазоваяПодсистемаКлиентСервер.РежимОтладки() И Не ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) Тогда
		СообщитьПрогресс = Ложь;
	КонецЕсли;

	Если Не ДоступноВыполнениеФоновыхЗаданий() Тогда
		ВызватьИсключение "Обновление параметров работы программы не может быть выполнено,
			|т.к. подключены расширения конфигурации, модифицирующие права в ролях конфигурации.
			|Для выполнения обновления необходимо отключить такие расширения.";
	КонецЕсли;

	Возврат БазоваяПодсистемаСервер.ВыполнитьВФоне(
		"РегистрыСведений.ПараметрыРаботыПрограммы.ОбработчикДлительнойОперацииЗагрузкиОбновления",
		СообщитьПрогресс,
		ПараметрыОперации);
КонецФункции

Процедура ОбработчикДлительнойОперацииЗагрузкиОбновления(СообщитьПрогресс, АдресХранилища) Экспорт
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("КраткоеПредставлениеОшибки",   Неопределено);
	РезультатВыполнения.Вставить("ПодробноеПредставлениеОшибки", Неопределено);

	Попытка
		ЗагрузитьОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс);
	Исключение
		ИнформацияОбОшибке									= ИнформацияОбОшибке();
		РезультатВыполнения.КраткоеПредставлениеОшибки		= КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		РезультатВыполнения.ПодробноеПредставлениеОшибки	= ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);

		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".

		// Зарезервировано для новых подсистем
	КонецПопытки;

	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
КонецПроцедуры

Функция ОбработанныйРезультатДлительнойОперации(Результат) Экспорт
	КраткоеПредставлениеОшибки   = Неопределено;
	ПодробноеПредставлениеОшибки = Неопределено;

	Если Результат = Неопределено Или Результат.Статус = "Отменено" Тогда
		КраткоеПредставлениеОшибки = "Не удалось обновить параметры работы программы по причине:
			           |Фоновое задание, выполняющее обновление отменено.";
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);

		Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
			КраткоеПредставлениеОшибки		= РезультатВыполнения.КраткоеПредставлениеОшибки;
			ПодробноеПредставлениеОшибки	= РезультатВыполнения.ПодробноеПредставлениеОшибки;
		Иначе
			КраткоеПредставлениеОшибки		= "Не удалось обновить параметры работы программы по причине:
				           |Фоновое задание, выполняющее обновление не вернуло результат.";
		КонецЕсли;
	ИначеЕсли Результат.Статус <> "ЗапускНеТребуется" Тогда
		// Ошибка выполнения фонового задания.
		КраткоеПредставлениеОшибки   = Результат.КраткоеПредставлениеОшибки;
		ПодробноеПредставлениеОшибки = Результат.ПодробноеПредставлениеОшибки;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) И ЗначениеЗаполнено(КраткоеПредставлениеОшибки) Тогда
		ПодробноеПредставлениеОшибки = КраткоеПредставлениеОшибки;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(КраткоеПредставлениеОшибки) И ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) Тогда
		КраткоеПредставлениеОшибки = ПодробноеПредставлениеОшибки;
	КонецЕсли;

	ОбработанныйРезультат = Новый Структура;
	ОбработанныйРезультат.Вставить("КраткоеПредставлениеОшибки",   КраткоеПредставлениеОшибки);
	ОбработанныйРезультат.Вставить("ПодробноеПредставлениеОшибки", ПодробноеПредставлениеОшибки);

	Если Не ЗначениеЗаполнено(КраткоеПредставлениеОшибки) Тогда
		ОбработатьПараметрыРаботыВерсийРасширений();
	КонецЕсли;

	Возврат ОбработанныйРезультат;
КонецФункции

Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс)
	БазоваяПодсистемаСервер.ПроверитьДинамическоеОбновлениеВерсииПрограммы();

	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения )И Не ВыполнятьОбновлениеБезФоновогоЗадания() Тогда
		ВызватьИсключение "Не удалось обновить параметры работы программы по причине: Найдены подключенные расширения конфигурации.";
	КонецЕсли;

	НастройкаПодчиненногоУзлаРИБ = Ложь;
	Если Не НеобходимоОбновление(НастройкаПодчиненногоУзлаРИБ) Тогда
		Возврат;
	КонецЕсли;

	// зарезервировано для новых подсистем

	УстановитьПривилегированныйРежим(Истина);
	Если БазоваяПодсистемаСервер.ЭтоПодчиненныйУзелРИБ() Тогда
		// Есть РИБ-обмен данными и обновление в подчиненном узле ИБ.

		// зарезервировано для новых подсистем

		Если Не НастройкаПодчиненногоУзлаРИБ Тогда
			// зарезервировано для новых подсистем

			Если СообщитьПрогресс Тогда
				БазоваяПодсистемаСервер.СообщитьПрогресс(5);
			КонецЕсли;
		КонецЕсли;

		// Проверка загрузки идентификаторов объектов метаданных из главного узла.
		СписокКритичныхИзменений = "";
		Попытка
			Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(Ложь, Ложь, Истина, , СписокКритичныхИзменений);
		Исключение
			// Переход в режим открытия формы повторной синхронизации данных перед запуском
			// с одним вариантом "Синхронизировать и продолжить".

			// зарезервировано для новых подсистем

			ВызватьИсключение;
		КонецПопытки;

		Если ЗначениеЗаполнено(СписокКритичныхИзменений) Тогда
			ИмяСобытия = "Идентификаторы объектов метаданных.Требуется загрузить критичные изменения";

			ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , СписокКритичныхИзменений);

			// Переход в режим открытия формы повторной синхронизации данных перед запуском
			// с одним вариантом "Синхронизировать и продолжить".

			// зарезервировано для новых подсистем

			ТекстОшибки = "Информационная база не может быть обновлена из-за проблемы в главном узле:
				           |- главный узел был некорректно обновлен (возможно не был увеличен номер версии конфигурации,
				           |  из-за чего не заполнился справочник Идентификаторы объектов метаданных);
				           |- либо были отменены к выгрузке приоритетные данные (элементы
				           |  справочника Идентификаторы объектов метаданных).
				           |
				           |Необходимо заново выполнить обновление главного узла, зарегистрировать к выгрузке
				           |приоритетные данные и повторить синхронизацию данных:
				           |- в главном узле запустите программу с параметром /C ЗапуститьОбновлениеИнформационнойБазы;
				           |%1";

			Если НастройкаПодчиненногоУзлаРИБ Тогда
				// Настройка подчиненного узла РИБ при первом запуске.
				ТекстОшибки = СтрШаблон(ТекстОшибки, "- затем повторите создание подчиненного узла.");
			Иначе
				// Обновление подчиненного узла РИБ.
				ТекстОшибки = СтрШаблон(ТекстОшибки, "- затем повторите синхронизацию данных с этой информационной базой
					           | (сначала в главном узле, затем в этой информационной базе после перезапуска).");
			КонецЕсли;

			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		Если СообщитьПрогресс Тогда
			БазоваяПодсистемаСервер.СообщитьПрогресс(10);
		КонецЕсли;
	КонецЕсли;

	// Нет РИБ-обмена данными
	// или обновление в главном узле ИБ
	// или обновление при первом запуске подчиненного узла
	// или обновление после загрузки справочника "Идентификаторы объектов метаданных" из главного узла.
	ОбновитьПараметрыРаботыПрограммы(СообщитьПрогресс);

	// зарезервировано для новых подсистем
КонецПроцедуры

Процедура ОбновитьПараметрыРаботыПрограммы(СообщитьПрогресс = Ложь)
	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.СообщитьПрогресс(30);
	КонецЕсли;

	Если Не БазоваяПодсистемаСерверПовтИсп.ОтключитьИдентификаторыОбъектовМетаданных() Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(Ложь, Ложь, Ложь);
	КонецЕсли;
	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.СообщитьПрогресс(60);
	КонецЕсли;

	// Критичная проверка назначения ролей пользователей.
	ПользователиСервер.ПроверитьНазначениеРолей();

	// зарезервировано для новых подсистем

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.СообщитьПрогресс(100);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьПараметрыРаботыВерсийРасширений()
	УстановитьПривилегированныйРежим(Истина);
	ПараметрЗапускаКлиента = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
	УстановитьПривилегированныйРежим(Ложь);
	Если СтрНайти(НРег(ПараметрЗапускаКлиента), НРег("ЗапуститьОбновлениеИнформационнойБазы")) > 0 Тогда
		РегистрыСведений.ПараметрыРаботыВерсийРасширений.ОчиститьВсеПараметрыРаботыРасширений();
	КонецЕсли;

	РегистрыСведений.ПараметрыРаботыВерсийРасширений.ЗаполнитьВсеПараметрыРаботыРасширений();
КонецПроцедуры

Функция ЕстьРолиМодифицированныеРасширениями()
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если Роль.ЕстьИзмененияРасширениямиКонфигурации() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;
КонецФункции

Функция ДоступноВыполнениеФоновыхЗаданий()
	Если ТекущийРежимЗапуска() = Неопределено И БазоваяПодсистемаСервер.ИнформационнаяБазаФайловая() Тогда
		Сеанс	= ПолучитьТекущийСеансИнформационнойБазы();
		Если Сеанс.ИмяПриложения = "COMConnection" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Истина;
КонецФункции

Функция ВыполнятьОбновлениеБезФоновогоЗадания()
	Если Не ДоступноВыполнениеФоновыхЗаданий() И Не ЕстьРолиМодифицированныеРасширениями() Тогда
		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;
КонецФункции

#КонецЕсли