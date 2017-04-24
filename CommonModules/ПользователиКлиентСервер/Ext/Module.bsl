﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи"
//
////////////////////////////////////////////////////////////////////////////////

// Возвращает Истина, если вход в сеанс выполнил внешний пользователь.
//
// Возвращаемое значение:
//  Булево - Истина, если вход в сеанс выполнил внешний пользователь.
//
Функция ЭтоСеансВнешнегоПользователя() Экспорт
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ПользователиСерверПовтИсп.ЭтоСеансВнешнегоПользователя();
#Иначе
	Возврат БазоваяПодсистемаКлиент.ПараметрКлиента("ЭтоСеансВнешнегоПользователя");
#КонецЕсли
КонецФункции

// Возвращает текущего пользователя или текущего внешнего пользователя,
// в зависимости от того, кто выполнил вход в сеанс.
//  Рекомендуется использовать в коде, который поддерживает работу в обоих случаях.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - пользователь
//    или внешний пользователь.
//
Функция АвторизованныйПользователь() Экспорт
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	УстановитьПривилегированныйРежим(Истина);

	Возврат ?(ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь),
	          ПараметрыСеанса.ТекущийПользователь,
	          ПараметрыСеанса.ТекущийВнешнийПользователь);
#Иначе
	Возврат БазоваяПодсистемаКлиент.ПараметрКлиента("АвторизованныйПользователь");
#КонецЕсли
КонецФункции

// Устанавливает доступность кнопки ЗаписатьИЗакрыть в формах, где
// требуется задать вопрос пользователю ПередЗаписью объекта на клиенте
// с установкой Отказ = Истина и повторным вызовом метода формы Записать.
//
// Чтобы процедуру можно было вызвать на клиенте, в форму должен быть добавлен
// реквизит ПравоРедактированиеОбъекта типа Произвольный.
// Этот реквизит инициализируется при первом вызове на стороне сервере (из обработчика
// события формы ПриСозданииНаСервере) и далее используется при вызове на клиенте,
// когда меняется свойство формы ТолькоПросмотр.
//
// Параметры:
//  Форма - УправляемаяФорма - форма элемента справочника, документа, ...
//  ОсновнойРеквизит - Строка - имя реквизита формы, содержащего структуру объекта.
//  ИмяЭлемента - Строка - имя элемента формы с кнопкой ЗаписатьИЗакрыть.
//
Процедура УстановитьДоступностьКнопкиЗаписатьИЗакрыть(Форма, ОсновнойРеквизит = "Объект", ИмяЭлемента = "ФормаЗаписатьИЗакрыть") Экспорт
	Права = Новый Структура("ПравоРедактированияОбъекта");
	ЗаполнитьЗначенияСвойств(Права, Форма);

	Если Права.ПравоРедактированияОбъекта = Неопределено Тогда
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Права.ПравоРедактированияОбъекта = ПравоДоступа("Редактирование", Форма[ОсновнойРеквизит].Ссылка.Метаданные());
		ЗаполнитьЗначенияСвойств(Форма, Права);
	#КонецЕсли
	КонецЕсли;

	ДоступностьКнопки = Не Форма.ТолькоПросмотр И Права.ПравоРедактированияОбъекта;
	Если Форма.Элементы[ИмяЭлемента].Доступность <> ДоступностьКнопки Тогда
		Форма.Элементы[ИмяЭлемента].Доступность = ДоступностьКнопки;
	КонецЕсли;
КонецПроцедуры

// Вычисляет начальное имя для входа по полному имени пользователя.
Функция ПолучитьКраткоеИмяПользователяИБ(Знач ПолноеИмя) Экспорт
	Разделители = Новый Массив;
	Разделители.Добавить(" ");
	Разделители.Добавить(".");

	КраткоеИмя = "";
	Для Счетчик = 1 По 3 Цикл
		Если Счетчик <> 1 Тогда
			КраткоеИмя = КраткоеИмя + ВРег(Лев(ПолноеИмя, 1));
		КонецЕсли;

		ПозицияРазделителя = 0;
		Для каждого Разделитель Из Разделители Цикл
			ПозицияТекущегоРазделителя = СтрНайти(ПолноеИмя, Разделитель);
			Если ПозицияТекущегоРазделителя > 0 И (ПозицияРазделителя = 0 ИЛИ ПозицияРазделителя > ПозицияТекущегоРазделителя ) Тогда
				ПозицияРазделителя = ПозицияТекущегоРазделителя;
			КонецЕсли;
		КонецЦикла;

		Если ПозицияРазделителя = 0 Тогда
			Если Счетчик = 1 Тогда
				КраткоеИмя = ПолноеИмя;
			КонецЕсли;

			Прервать;
		КонецЕсли;

		Если Счетчик = 1 Тогда
			КраткоеИмя = Лев(ПолноеИмя, ПозицияРазделителя - 1);
		КонецЕсли;

		ПолноеИмя = Прав(ПолноеИмя, СтрДлина(ПолноеИмя) - ПозицияРазделителя);
		Пока Разделители.Найти(Лев(ПолноеИмя, 1)) <> Неопределено Цикл
			ПолноеИмя = Сред(ПолноеИмя, 2);
		КонецЦикла;
	КонецЦикла;

	Возврат КраткоеИмя;
КонецФункции

Процедура ОбновитьОграничениеСрокаДействия(Форма) Экспорт
	Элементы = Форма.Элементы;

	Элементы.ИзменитьОграничениеНаВходВПрограмму.Видимость = Элементы.СвойстваПользователяИБ.Видимость И Форма.УровеньДоступа.УправлениеСписком;

	Если Не Элементы.СвойстваПользователяИБ.Видимость Тогда
		Элементы.ВходВПрограммуРазрешен.Заголовок = "";

		Возврат;
	КонецЕсли;

	Элементы.ИзменитьОграничениеНаВходВПрограмму.Доступность = Форма.УровеньДоступа.НастройкиДляВхода;

	ЗаголовокСОграничением = "";

	Если Форма.СрокДействияНеОграничен Тогда
		ЗаголовокСОграничением = "Вход в программу разрешен (без ограничения срока)";
	ИначеЕсли ЗначениеЗаполнено(Форма.СрокДействия) Тогда
		ЗаголовокСОграничением = СтрШаблон("Вход в программу разрешен (до %1)", Формат(Форма.СрокДействия, "ДЛФ=D"));
	ИначеЕсли ЗначениеЗаполнено(Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода) Тогда
		ЗаголовокСОграничением = СтрШаблон("Вход в программу разрешен (запретить, если не работает более %1)", СтрокаСЧислом("; день; ; дня; дней; дня", Форма.ПросрочкаРаботыВПрограммеДоЗапрещенияВхода, ВидЧисловогоЗначения.Количественное,"L=ru"));
	КонецЕсли;

	Если ЗначениеЗаполнено(ЗаголовокСОграничением) Тогда
		Элементы.ВходВПрограммуРазрешен.Заголовок = ЗаголовокСОграничением;
		Элементы.ИзменитьОграничениеНаВходВПрограмму.Заголовок = "Изменить ограничение";
	Иначе
		Элементы.ВходВПрограммуРазрешен.Заголовок = "";
		Элементы.ИзменитьОграничениеНаВходВПрограмму.Заголовок = "Установить ограничение";
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьНаличиеПароля(Форма, ПарольУстановлен) Экспорт
	Элементы = Форма.Элементы;

	Если ПарольУстановлен Тогда
		Элементы.НадписьНаличиеПароля.Заголовок				= "Пароль установлен";
		Элементы.ПотребоватьСменуПароляПриВходе.Заголовок	= "Потребовать смену пароля при входе";
	Иначе
		Элементы.НадписьНаличиеПароля.Заголовок				= "Пустой пароль";
		Элементы.ПотребоватьСменуПароляПриВходе.Заголовок	= "Потребовать установку пароля при входе";
	КонецЕсли;

	Если ПарольУстановлен И Форма.Объект.Ссылка = АвторизованныйПользователь() Тогда
		Элементы.СменитьПароль.Заголовок = "Сменить пароль...";
	Иначе
		Элементы.СменитьПароль.Заголовок = "Установить пароль...";
	КонецЕсли;
КонецПроцедуры
