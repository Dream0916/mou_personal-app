// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<String> startDate = GeneratedColumn<String>(
      'start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<String> endDate = GeneratedColumn<String>(
      'end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _projectStartDateMeta =
      const VerificationMeta('projectStartDate');
  @override
  late final GeneratedColumn<String> projectStartDate = GeneratedColumn<String>(
      'project_start_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _projectEndDateMeta =
      const VerificationMeta('projectEndDate');
  @override
  late final GeneratedColumn<String> projectEndDate = GeneratedColumn<String>(
      'project_end_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _commentMeta =
      const VerificationMeta('comment');
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
      'comment', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
      'repeat', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _alarmMeta = const VerificationMeta('alarm');
  @override
  late final GeneratedColumn<String> alarm = GeneratedColumn<String>(
      'alarm', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
      'place', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _busyModeMeta =
      const VerificationMeta('busyMode');
  @override
  late final GeneratedColumn<int> busyMode = GeneratedColumn<int>(
      'busy_mode', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _creatorMeta =
      const VerificationMeta('creator');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      creator = GeneratedColumn<String>('creator', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>(
              $EventsTable.$convertercreatorn);
  static const VerificationMeta _usersMeta = const VerificationMeta('users');
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>?, String> users =
      GeneratedColumn<String>('users', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<dynamic>?>($EventsTable.$converterusersn);
  static const VerificationMeta _waitingToConfirmMeta =
      const VerificationMeta('waitingToConfirm');
  @override
  late final GeneratedColumn<bool> waitingToConfirm = GeneratedColumn<bool>(
      'waiting_to_confirm', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("waiting_to_confirm" IN (0, 1))'));
  static const VerificationMeta _eventStatusMeta =
      const VerificationMeta('eventStatus');
  @override
  late final GeneratedColumnWithTypeConverter<EventStatus?, String>
      eventStatus = GeneratedColumn<String>('event_status', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<EventStatus?>($EventsTable.$convertereventStatusn);
  static const VerificationMeta _workStatusMeta =
      const VerificationMeta('workStatus');
  @override
  late final GeneratedColumnWithTypeConverter<WorkStatus?, String> workStatus =
      GeneratedColumn<String>('work_status', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<WorkStatus?>($EventsTable.$converterworkStatusn);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<EventTaskType?, String> type =
      GeneratedColumn<String>('type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<EventTaskType?>($EventsTable.$convertertypen);
  static const VerificationMeta _projectNameMeta =
      const VerificationMeta('projectName');
  @override
  late final GeneratedColumn<String> projectName = GeneratedColumn<String>(
      'project_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _companyPhotoMeta =
      const VerificationMeta('companyPhoto');
  @override
  late final GeneratedColumn<String> companyPhoto = GeneratedColumn<String>(
      'company_photo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _companyNameMeta =
      const VerificationMeta('companyName');
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
      'company_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _storeNameMeta =
      const VerificationMeta('storeName');
  @override
  late final GeneratedColumn<String> storeName = GeneratedColumn<String>(
      'store_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _doneTimeMeta =
      const VerificationMeta('doneTime');
  @override
  late final GeneratedColumn<String> doneTime = GeneratedColumn<String>(
      'done_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateLocalMeta =
      const VerificationMeta('dateLocal');
  @override
  late final GeneratedColumn<DateTime> dateLocal = GeneratedColumn<DateTime>(
      'date_local', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scopeNameMeta =
      const VerificationMeta('scopeName');
  @override
  late final GeneratedColumn<String> scopeName = GeneratedColumn<String>(
      'scope_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _clientNameMeta =
      const VerificationMeta('clientName');
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
      'client_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _leaderNameMeta =
      const VerificationMeta('leaderName');
  @override
  late final GeneratedColumn<String> leaderName = GeneratedColumn<String>(
      'leader_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pageTypeMeta =
      const VerificationMeta('pageType');
  @override
  late final GeneratedColumnWithTypeConverter<EventPageType?, String> pageType =
      GeneratedColumn<String>('page_type', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<EventPageType?>($EventsTable.$converterpageTypen);
  static const VerificationMeta _sortMeta = const VerificationMeta('sort');
  @override
  late final GeneratedColumn<int> sort = GeneratedColumn<int>(
      'sort', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _showEndDateMeta =
      const VerificationMeta('showEndDate');
  @override
  late final GeneratedColumn<bool> showEndDate = GeneratedColumn<bool>(
      'show_end_date', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_end_date" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        startDate,
        endDate,
        projectStartDate,
        projectEndDate,
        comment,
        repeat,
        alarm,
        place,
        busyMode,
        creator,
        users,
        waitingToConfirm,
        eventStatus,
        workStatus,
        type,
        projectName,
        companyPhoto,
        companyName,
        storeName,
        doneTime,
        dateLocal,
        status,
        scopeName,
        clientName,
        leaderName,
        pageType,
        sort,
        showEndDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(Insertable<Event> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('project_start_date')) {
      context.handle(
          _projectStartDateMeta,
          projectStartDate.isAcceptableOrUnknown(
              data['project_start_date']!, _projectStartDateMeta));
    }
    if (data.containsKey('project_end_date')) {
      context.handle(
          _projectEndDateMeta,
          projectEndDate.isAcceptableOrUnknown(
              data['project_end_date']!, _projectEndDateMeta));
    }
    if (data.containsKey('comment')) {
      context.handle(_commentMeta,
          comment.isAcceptableOrUnknown(data['comment']!, _commentMeta));
    }
    if (data.containsKey('repeat')) {
      context.handle(_repeatMeta,
          repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta));
    }
    if (data.containsKey('alarm')) {
      context.handle(
          _alarmMeta, alarm.isAcceptableOrUnknown(data['alarm']!, _alarmMeta));
    }
    if (data.containsKey('place')) {
      context.handle(
          _placeMeta, place.isAcceptableOrUnknown(data['place']!, _placeMeta));
    }
    if (data.containsKey('busy_mode')) {
      context.handle(_busyModeMeta,
          busyMode.isAcceptableOrUnknown(data['busy_mode']!, _busyModeMeta));
    }
    context.handle(_creatorMeta, const VerificationResult.success());
    context.handle(_usersMeta, const VerificationResult.success());
    if (data.containsKey('waiting_to_confirm')) {
      context.handle(
          _waitingToConfirmMeta,
          waitingToConfirm.isAcceptableOrUnknown(
              data['waiting_to_confirm']!, _waitingToConfirmMeta));
    }
    context.handle(_eventStatusMeta, const VerificationResult.success());
    context.handle(_workStatusMeta, const VerificationResult.success());
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('project_name')) {
      context.handle(
          _projectNameMeta,
          projectName.isAcceptableOrUnknown(
              data['project_name']!, _projectNameMeta));
    }
    if (data.containsKey('company_photo')) {
      context.handle(
          _companyPhotoMeta,
          companyPhoto.isAcceptableOrUnknown(
              data['company_photo']!, _companyPhotoMeta));
    }
    if (data.containsKey('company_name')) {
      context.handle(
          _companyNameMeta,
          companyName.isAcceptableOrUnknown(
              data['company_name']!, _companyNameMeta));
    }
    if (data.containsKey('store_name')) {
      context.handle(_storeNameMeta,
          storeName.isAcceptableOrUnknown(data['store_name']!, _storeNameMeta));
    }
    if (data.containsKey('done_time')) {
      context.handle(_doneTimeMeta,
          doneTime.isAcceptableOrUnknown(data['done_time']!, _doneTimeMeta));
    }
    if (data.containsKey('date_local')) {
      context.handle(_dateLocalMeta,
          dateLocal.isAcceptableOrUnknown(data['date_local']!, _dateLocalMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('scope_name')) {
      context.handle(_scopeNameMeta,
          scopeName.isAcceptableOrUnknown(data['scope_name']!, _scopeNameMeta));
    }
    if (data.containsKey('client_name')) {
      context.handle(
          _clientNameMeta,
          clientName.isAcceptableOrUnknown(
              data['client_name']!, _clientNameMeta));
    }
    if (data.containsKey('leader_name')) {
      context.handle(
          _leaderNameMeta,
          leaderName.isAcceptableOrUnknown(
              data['leader_name']!, _leaderNameMeta));
    }
    context.handle(_pageTypeMeta, const VerificationResult.success());
    if (data.containsKey('sort')) {
      context.handle(
          _sortMeta, sort.isAcceptableOrUnknown(data['sort']!, _sortMeta));
    }
    if (data.containsKey('show_end_date')) {
      context.handle(
          _showEndDateMeta,
          showEndDate.isAcceptableOrUnknown(
              data['show_end_date']!, _showEndDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, dateLocal, pageType};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}start_date']),
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}end_date']),
      projectStartDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}project_start_date']),
      projectEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}project_end_date']),
      comment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}comment']),
      repeat: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}repeat']),
      alarm: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alarm']),
      place: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}place']),
      busyMode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}busy_mode']),
      creator: $EventsTable.$convertercreatorn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator'])),
      users: $EventsTable.$converterusersn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}users'])),
      waitingToConfirm: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}waiting_to_confirm']),
      eventStatus: $EventsTable.$convertereventStatusn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}event_status'])),
      workStatus: $EventsTable.$converterworkStatusn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}work_status'])),
      type: $EventsTable.$convertertypen.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])),
      projectName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_name']),
      companyPhoto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_photo']),
      companyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}company_name']),
      storeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}store_name']),
      doneTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}done_time']),
      dateLocal: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_local']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      scopeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scope_name']),
      clientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_name']),
      leaderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}leader_name']),
      pageType: $EventsTable.$converterpageTypen.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}page_type'])),
      sort: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort']),
      showEndDate: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}show_end_date']),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertercreator =
      const MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $convertercreatorn =
      NullAwareTypeConverter.wrap($convertercreator);
  static TypeConverter<List<dynamic>, String> $converterusers =
      const ListConverter();
  static TypeConverter<List<dynamic>?, String?> $converterusersn =
      NullAwareTypeConverter.wrap($converterusers);
  static JsonTypeConverter2<EventStatus, String, String> $convertereventStatus =
      const EnumNameConverter<EventStatus>(EventStatus.values);
  static JsonTypeConverter2<EventStatus?, String?, String?>
      $convertereventStatusn =
      JsonTypeConverter2.asNullable($convertereventStatus);
  static JsonTypeConverter2<WorkStatus, String, String> $converterworkStatus =
      const EnumNameConverter<WorkStatus>(WorkStatus.values);
  static JsonTypeConverter2<WorkStatus?, String?, String?>
      $converterworkStatusn =
      JsonTypeConverter2.asNullable($converterworkStatus);
  static JsonTypeConverter2<EventTaskType, String, String> $convertertype =
      const EnumNameConverter<EventTaskType>(EventTaskType.values);
  static JsonTypeConverter2<EventTaskType?, String?, String?> $convertertypen =
      JsonTypeConverter2.asNullable($convertertype);
  static JsonTypeConverter2<EventPageType, String, String> $converterpageType =
      const EnumNameConverter<EventPageType>(EventPageType.values);
  static JsonTypeConverter2<EventPageType?, String?, String?>
      $converterpageTypen = JsonTypeConverter2.asNullable($converterpageType);
}

class Event extends DataClass implements Insertable<Event> {
  int id;
  String? title;
  String? startDate;
  String? endDate;
  String? projectStartDate;
  String? projectEndDate;
  String? comment;
  String? repeat;
  String? alarm;
  String? place;
  int? busyMode;
  Map<String, dynamic>? creator;
  List<dynamic>? users;
  bool? waitingToConfirm;
  EventStatus? eventStatus;
  WorkStatus? workStatus;
  EventTaskType? type;
  String? projectName;
  String? companyPhoto;
  String? companyName;
  String? storeName;
  String? doneTime;
  DateTime? dateLocal;
  String? status;
  String? scopeName;
  String? clientName;
  String? leaderName;
  EventPageType? pageType;
  int? sort;
  bool? showEndDate;
  Event(
      {required this.id,
      this.title,
      this.startDate,
      this.endDate,
      this.projectStartDate,
      this.projectEndDate,
      this.comment,
      this.repeat,
      this.alarm,
      this.place,
      this.busyMode,
      this.creator,
      this.users,
      this.waitingToConfirm,
      this.eventStatus,
      this.workStatus,
      this.type,
      this.projectName,
      this.companyPhoto,
      this.companyName,
      this.storeName,
      this.doneTime,
      this.dateLocal,
      this.status,
      this.scopeName,
      this.clientName,
      this.leaderName,
      this.pageType,
      this.sort,
      this.showEndDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<String>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<String>(endDate);
    }
    if (!nullToAbsent || projectStartDate != null) {
      map['project_start_date'] = Variable<String>(projectStartDate);
    }
    if (!nullToAbsent || projectEndDate != null) {
      map['project_end_date'] = Variable<String>(projectEndDate);
    }
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    if (!nullToAbsent || repeat != null) {
      map['repeat'] = Variable<String>(repeat);
    }
    if (!nullToAbsent || alarm != null) {
      map['alarm'] = Variable<String>(alarm);
    }
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || busyMode != null) {
      map['busy_mode'] = Variable<int>(busyMode);
    }
    if (!nullToAbsent || creator != null) {
      final converter = $EventsTable.$convertercreatorn;
      map['creator'] = Variable<String>(converter.toSql(creator));
    }
    if (!nullToAbsent || users != null) {
      final converter = $EventsTable.$converterusersn;
      map['users'] = Variable<String>(converter.toSql(users));
    }
    if (!nullToAbsent || waitingToConfirm != null) {
      map['waiting_to_confirm'] = Variable<bool>(waitingToConfirm);
    }
    if (!nullToAbsent || eventStatus != null) {
      final converter = $EventsTable.$convertereventStatusn;
      map['event_status'] = Variable<String>(converter.toSql(eventStatus));
    }
    if (!nullToAbsent || workStatus != null) {
      final converter = $EventsTable.$converterworkStatusn;
      map['work_status'] = Variable<String>(converter.toSql(workStatus));
    }
    if (!nullToAbsent || type != null) {
      final converter = $EventsTable.$convertertypen;
      map['type'] = Variable<String>(converter.toSql(type));
    }
    if (!nullToAbsent || projectName != null) {
      map['project_name'] = Variable<String>(projectName);
    }
    if (!nullToAbsent || companyPhoto != null) {
      map['company_photo'] = Variable<String>(companyPhoto);
    }
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    if (!nullToAbsent || storeName != null) {
      map['store_name'] = Variable<String>(storeName);
    }
    if (!nullToAbsent || doneTime != null) {
      map['done_time'] = Variable<String>(doneTime);
    }
    if (!nullToAbsent || dateLocal != null) {
      map['date_local'] = Variable<DateTime>(dateLocal);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || scopeName != null) {
      map['scope_name'] = Variable<String>(scopeName);
    }
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    if (!nullToAbsent || leaderName != null) {
      map['leader_name'] = Variable<String>(leaderName);
    }
    if (!nullToAbsent || pageType != null) {
      final converter = $EventsTable.$converterpageTypen;
      map['page_type'] = Variable<String>(converter.toSql(pageType));
    }
    if (!nullToAbsent || sort != null) {
      map['sort'] = Variable<int>(sort);
    }
    if (!nullToAbsent || showEndDate != null) {
      map['show_end_date'] = Variable<bool>(showEndDate);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      projectStartDate: projectStartDate == null && nullToAbsent
          ? const Value.absent()
          : Value(projectStartDate),
      projectEndDate: projectEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(projectEndDate),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      repeat:
          repeat == null && nullToAbsent ? const Value.absent() : Value(repeat),
      alarm:
          alarm == null && nullToAbsent ? const Value.absent() : Value(alarm),
      place:
          place == null && nullToAbsent ? const Value.absent() : Value(place),
      busyMode: busyMode == null && nullToAbsent
          ? const Value.absent()
          : Value(busyMode),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      users:
          users == null && nullToAbsent ? const Value.absent() : Value(users),
      waitingToConfirm: waitingToConfirm == null && nullToAbsent
          ? const Value.absent()
          : Value(waitingToConfirm),
      eventStatus: eventStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(eventStatus),
      workStatus: workStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(workStatus),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      projectName: projectName == null && nullToAbsent
          ? const Value.absent()
          : Value(projectName),
      companyPhoto: companyPhoto == null && nullToAbsent
          ? const Value.absent()
          : Value(companyPhoto),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      storeName: storeName == null && nullToAbsent
          ? const Value.absent()
          : Value(storeName),
      doneTime: doneTime == null && nullToAbsent
          ? const Value.absent()
          : Value(doneTime),
      dateLocal: dateLocal == null && nullToAbsent
          ? const Value.absent()
          : Value(dateLocal),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      scopeName: scopeName == null && nullToAbsent
          ? const Value.absent()
          : Value(scopeName),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      leaderName: leaderName == null && nullToAbsent
          ? const Value.absent()
          : Value(leaderName),
      pageType: pageType == null && nullToAbsent
          ? const Value.absent()
          : Value(pageType),
      sort: sort == null && nullToAbsent ? const Value.absent() : Value(sort),
      showEndDate: showEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(showEndDate),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      startDate: serializer.fromJson<String?>(json['start_date']),
      endDate: serializer.fromJson<String?>(json['end_date']),
      projectStartDate:
          serializer.fromJson<String?>(json['project_start_date']),
      projectEndDate: serializer.fromJson<String?>(json['project_end_date']),
      comment: serializer.fromJson<String?>(json['comment']),
      repeat: serializer.fromJson<String?>(json['repeat']),
      alarm: serializer.fromJson<String?>(json['alarm']),
      place: serializer.fromJson<String?>(json['place']),
      busyMode: serializer.fromJson<int?>(json['busy_mode']),
      creator: serializer.fromJson<Map<String, dynamic>?>(json['creator']),
      users: serializer.fromJson<List<dynamic>?>(json['users']),
      waitingToConfirm: serializer.fromJson<bool?>(json['waiting_to_confirm']),
      eventStatus: $EventsTable.$convertereventStatusn
          .fromJson(serializer.fromJson<String?>(json['eventStatus'])),
      workStatus: $EventsTable.$converterworkStatusn
          .fromJson(serializer.fromJson<String?>(json['workStatus'])),
      type: $EventsTable.$convertertypen
          .fromJson(serializer.fromJson<String?>(json['type'])),
      projectName: serializer.fromJson<String?>(json['project_name']),
      companyPhoto: serializer.fromJson<String?>(json['company_photo']),
      companyName: serializer.fromJson<String?>(json['company_name']),
      storeName: serializer.fromJson<String?>(json['store_name']),
      doneTime: serializer.fromJson<String?>(json['done_time']),
      dateLocal: serializer.fromJson<DateTime?>(json['dateLocal']),
      status: serializer.fromJson<String?>(json['status']),
      scopeName: serializer.fromJson<String?>(json['scope_name']),
      clientName: serializer.fromJson<String?>(json['client_name']),
      leaderName: serializer.fromJson<String?>(json['leader_name']),
      pageType: $EventsTable.$converterpageTypen
          .fromJson(serializer.fromJson<String?>(json['page_type'])),
      sort: serializer.fromJson<int?>(json['sort']),
      showEndDate: serializer.fromJson<bool?>(json['show_end_date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'start_date': serializer.toJson<String?>(startDate),
      'end_date': serializer.toJson<String?>(endDate),
      'project_start_date': serializer.toJson<String?>(projectStartDate),
      'project_end_date': serializer.toJson<String?>(projectEndDate),
      'comment': serializer.toJson<String?>(comment),
      'repeat': serializer.toJson<String?>(repeat),
      'alarm': serializer.toJson<String?>(alarm),
      'place': serializer.toJson<String?>(place),
      'busy_mode': serializer.toJson<int?>(busyMode),
      'creator': serializer.toJson<Map<String, dynamic>?>(creator),
      'users': serializer.toJson<List<dynamic>?>(users),
      'waiting_to_confirm': serializer.toJson<bool?>(waitingToConfirm),
      'eventStatus': serializer.toJson<String?>(
          $EventsTable.$convertereventStatusn.toJson(eventStatus)),
      'workStatus': serializer.toJson<String?>(
          $EventsTable.$converterworkStatusn.toJson(workStatus)),
      'type':
          serializer.toJson<String?>($EventsTable.$convertertypen.toJson(type)),
      'project_name': serializer.toJson<String?>(projectName),
      'company_photo': serializer.toJson<String?>(companyPhoto),
      'company_name': serializer.toJson<String?>(companyName),
      'store_name': serializer.toJson<String?>(storeName),
      'done_time': serializer.toJson<String?>(doneTime),
      'dateLocal': serializer.toJson<DateTime?>(dateLocal),
      'status': serializer.toJson<String?>(status),
      'scope_name': serializer.toJson<String?>(scopeName),
      'client_name': serializer.toJson<String?>(clientName),
      'leader_name': serializer.toJson<String?>(leaderName),
      'page_type': serializer
          .toJson<String?>($EventsTable.$converterpageTypen.toJson(pageType)),
      'sort': serializer.toJson<int?>(sort),
      'show_end_date': serializer.toJson<bool?>(showEndDate),
    };
  }

  Event copyWith(
          {int? id,
          Value<String?> title = const Value.absent(),
          Value<String?> startDate = const Value.absent(),
          Value<String?> endDate = const Value.absent(),
          Value<String?> projectStartDate = const Value.absent(),
          Value<String?> projectEndDate = const Value.absent(),
          Value<String?> comment = const Value.absent(),
          Value<String?> repeat = const Value.absent(),
          Value<String?> alarm = const Value.absent(),
          Value<String?> place = const Value.absent(),
          Value<int?> busyMode = const Value.absent(),
          Value<Map<String, dynamic>?> creator = const Value.absent(),
          Value<List<dynamic>?> users = const Value.absent(),
          Value<bool?> waitingToConfirm = const Value.absent(),
          Value<EventStatus?> eventStatus = const Value.absent(),
          Value<WorkStatus?> workStatus = const Value.absent(),
          Value<EventTaskType?> type = const Value.absent(),
          Value<String?> projectName = const Value.absent(),
          Value<String?> companyPhoto = const Value.absent(),
          Value<String?> companyName = const Value.absent(),
          Value<String?> storeName = const Value.absent(),
          Value<String?> doneTime = const Value.absent(),
          Value<DateTime?> dateLocal = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> scopeName = const Value.absent(),
          Value<String?> clientName = const Value.absent(),
          Value<String?> leaderName = const Value.absent(),
          Value<EventPageType?> pageType = const Value.absent(),
          Value<int?> sort = const Value.absent(),
          Value<bool?> showEndDate = const Value.absent()}) =>
      Event(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        startDate: startDate.present ? startDate.value : this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        projectStartDate: projectStartDate.present
            ? projectStartDate.value
            : this.projectStartDate,
        projectEndDate:
            projectEndDate.present ? projectEndDate.value : this.projectEndDate,
        comment: comment.present ? comment.value : this.comment,
        repeat: repeat.present ? repeat.value : this.repeat,
        alarm: alarm.present ? alarm.value : this.alarm,
        place: place.present ? place.value : this.place,
        busyMode: busyMode.present ? busyMode.value : this.busyMode,
        creator: creator.present ? creator.value : this.creator,
        users: users.present ? users.value : this.users,
        waitingToConfirm: waitingToConfirm.present
            ? waitingToConfirm.value
            : this.waitingToConfirm,
        eventStatus: eventStatus.present ? eventStatus.value : this.eventStatus,
        workStatus: workStatus.present ? workStatus.value : this.workStatus,
        type: type.present ? type.value : this.type,
        projectName: projectName.present ? projectName.value : this.projectName,
        companyPhoto:
            companyPhoto.present ? companyPhoto.value : this.companyPhoto,
        companyName: companyName.present ? companyName.value : this.companyName,
        storeName: storeName.present ? storeName.value : this.storeName,
        doneTime: doneTime.present ? doneTime.value : this.doneTime,
        dateLocal: dateLocal.present ? dateLocal.value : this.dateLocal,
        status: status.present ? status.value : this.status,
        scopeName: scopeName.present ? scopeName.value : this.scopeName,
        clientName: clientName.present ? clientName.value : this.clientName,
        leaderName: leaderName.present ? leaderName.value : this.leaderName,
        pageType: pageType.present ? pageType.value : this.pageType,
        sort: sort.present ? sort.value : this.sort,
        showEndDate: showEndDate.present ? showEndDate.value : this.showEndDate,
      );
  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('projectStartDate: $projectStartDate, ')
          ..write('projectEndDate: $projectEndDate, ')
          ..write('comment: $comment, ')
          ..write('repeat: $repeat, ')
          ..write('alarm: $alarm, ')
          ..write('place: $place, ')
          ..write('busyMode: $busyMode, ')
          ..write('creator: $creator, ')
          ..write('users: $users, ')
          ..write('waitingToConfirm: $waitingToConfirm, ')
          ..write('eventStatus: $eventStatus, ')
          ..write('workStatus: $workStatus, ')
          ..write('type: $type, ')
          ..write('projectName: $projectName, ')
          ..write('companyPhoto: $companyPhoto, ')
          ..write('companyName: $companyName, ')
          ..write('storeName: $storeName, ')
          ..write('doneTime: $doneTime, ')
          ..write('dateLocal: $dateLocal, ')
          ..write('status: $status, ')
          ..write('scopeName: $scopeName, ')
          ..write('clientName: $clientName, ')
          ..write('leaderName: $leaderName, ')
          ..write('pageType: $pageType, ')
          ..write('sort: $sort, ')
          ..write('showEndDate: $showEndDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        title,
        startDate,
        endDate,
        projectStartDate,
        projectEndDate,
        comment,
        repeat,
        alarm,
        place,
        busyMode,
        creator,
        users,
        waitingToConfirm,
        eventStatus,
        workStatus,
        type,
        projectName,
        companyPhoto,
        companyName,
        storeName,
        doneTime,
        dateLocal,
        status,
        scopeName,
        clientName,
        leaderName,
        pageType,
        sort,
        showEndDate
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.title == this.title &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.projectStartDate == this.projectStartDate &&
          other.projectEndDate == this.projectEndDate &&
          other.comment == this.comment &&
          other.repeat == this.repeat &&
          other.alarm == this.alarm &&
          other.place == this.place &&
          other.busyMode == this.busyMode &&
          other.creator == this.creator &&
          other.users == this.users &&
          other.waitingToConfirm == this.waitingToConfirm &&
          other.eventStatus == this.eventStatus &&
          other.workStatus == this.workStatus &&
          other.type == this.type &&
          other.projectName == this.projectName &&
          other.companyPhoto == this.companyPhoto &&
          other.companyName == this.companyName &&
          other.storeName == this.storeName &&
          other.doneTime == this.doneTime &&
          other.dateLocal == this.dateLocal &&
          other.status == this.status &&
          other.scopeName == this.scopeName &&
          other.clientName == this.clientName &&
          other.leaderName == this.leaderName &&
          other.pageType == this.pageType &&
          other.sort == this.sort &&
          other.showEndDate == this.showEndDate);
}

class EventsCompanion extends UpdateCompanion<Event> {
  Value<int> id;
  Value<String?> title;
  Value<String?> startDate;
  Value<String?> endDate;
  Value<String?> projectStartDate;
  Value<String?> projectEndDate;
  Value<String?> comment;
  Value<String?> repeat;
  Value<String?> alarm;
  Value<String?> place;
  Value<int?> busyMode;
  Value<Map<String, dynamic>?> creator;
  Value<List<dynamic>?> users;
  Value<bool?> waitingToConfirm;
  Value<EventStatus?> eventStatus;
  Value<WorkStatus?> workStatus;
  Value<EventTaskType?> type;
  Value<String?> projectName;
  Value<String?> companyPhoto;
  Value<String?> companyName;
  Value<String?> storeName;
  Value<String?> doneTime;
  Value<DateTime?> dateLocal;
  Value<String?> status;
  Value<String?> scopeName;
  Value<String?> clientName;
  Value<String?> leaderName;
  Value<EventPageType?> pageType;
  Value<int?> sort;
  Value<bool?> showEndDate;
  Value<int> rowid;
  EventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.projectStartDate = const Value.absent(),
    this.projectEndDate = const Value.absent(),
    this.comment = const Value.absent(),
    this.repeat = const Value.absent(),
    this.alarm = const Value.absent(),
    this.place = const Value.absent(),
    this.busyMode = const Value.absent(),
    this.creator = const Value.absent(),
    this.users = const Value.absent(),
    this.waitingToConfirm = const Value.absent(),
    this.eventStatus = const Value.absent(),
    this.workStatus = const Value.absent(),
    this.type = const Value.absent(),
    this.projectName = const Value.absent(),
    this.companyPhoto = const Value.absent(),
    this.companyName = const Value.absent(),
    this.storeName = const Value.absent(),
    this.doneTime = const Value.absent(),
    this.dateLocal = const Value.absent(),
    this.status = const Value.absent(),
    this.scopeName = const Value.absent(),
    this.clientName = const Value.absent(),
    this.leaderName = const Value.absent(),
    this.pageType = const Value.absent(),
    this.sort = const Value.absent(),
    this.showEndDate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventsCompanion.insert({
    required int id,
    this.title = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.projectStartDate = const Value.absent(),
    this.projectEndDate = const Value.absent(),
    this.comment = const Value.absent(),
    this.repeat = const Value.absent(),
    this.alarm = const Value.absent(),
    this.place = const Value.absent(),
    this.busyMode = const Value.absent(),
    this.creator = const Value.absent(),
    this.users = const Value.absent(),
    this.waitingToConfirm = const Value.absent(),
    this.eventStatus = const Value.absent(),
    this.workStatus = const Value.absent(),
    this.type = const Value.absent(),
    this.projectName = const Value.absent(),
    this.companyPhoto = const Value.absent(),
    this.companyName = const Value.absent(),
    this.storeName = const Value.absent(),
    this.doneTime = const Value.absent(),
    this.dateLocal = const Value.absent(),
    this.status = const Value.absent(),
    this.scopeName = const Value.absent(),
    this.clientName = const Value.absent(),
    this.leaderName = const Value.absent(),
    this.pageType = const Value.absent(),
    this.sort = const Value.absent(),
    this.showEndDate = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? startDate,
    Expression<String>? endDate,
    Expression<String>? projectStartDate,
    Expression<String>? projectEndDate,
    Expression<String>? comment,
    Expression<String>? repeat,
    Expression<String>? alarm,
    Expression<String>? place,
    Expression<int>? busyMode,
    Expression<String>? creator,
    Expression<String>? users,
    Expression<bool>? waitingToConfirm,
    Expression<String>? eventStatus,
    Expression<String>? workStatus,
    Expression<String>? type,
    Expression<String>? projectName,
    Expression<String>? companyPhoto,
    Expression<String>? companyName,
    Expression<String>? storeName,
    Expression<String>? doneTime,
    Expression<DateTime>? dateLocal,
    Expression<String>? status,
    Expression<String>? scopeName,
    Expression<String>? clientName,
    Expression<String>? leaderName,
    Expression<String>? pageType,
    Expression<int>? sort,
    Expression<bool>? showEndDate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (projectStartDate != null) 'project_start_date': projectStartDate,
      if (projectEndDate != null) 'project_end_date': projectEndDate,
      if (comment != null) 'comment': comment,
      if (repeat != null) 'repeat': repeat,
      if (alarm != null) 'alarm': alarm,
      if (place != null) 'place': place,
      if (busyMode != null) 'busy_mode': busyMode,
      if (creator != null) 'creator': creator,
      if (users != null) 'users': users,
      if (waitingToConfirm != null) 'waiting_to_confirm': waitingToConfirm,
      if (eventStatus != null) 'event_status': eventStatus,
      if (workStatus != null) 'work_status': workStatus,
      if (type != null) 'type': type,
      if (projectName != null) 'project_name': projectName,
      if (companyPhoto != null) 'company_photo': companyPhoto,
      if (companyName != null) 'company_name': companyName,
      if (storeName != null) 'store_name': storeName,
      if (doneTime != null) 'done_time': doneTime,
      if (dateLocal != null) 'date_local': dateLocal,
      if (status != null) 'status': status,
      if (scopeName != null) 'scope_name': scopeName,
      if (clientName != null) 'client_name': clientName,
      if (leaderName != null) 'leader_name': leaderName,
      if (pageType != null) 'page_type': pageType,
      if (sort != null) 'sort': sort,
      if (showEndDate != null) 'show_end_date': showEndDate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? title,
      Value<String?>? startDate,
      Value<String?>? endDate,
      Value<String?>? projectStartDate,
      Value<String?>? projectEndDate,
      Value<String?>? comment,
      Value<String?>? repeat,
      Value<String?>? alarm,
      Value<String?>? place,
      Value<int?>? busyMode,
      Value<Map<String, dynamic>?>? creator,
      Value<List<dynamic>?>? users,
      Value<bool?>? waitingToConfirm,
      Value<EventStatus?>? eventStatus,
      Value<WorkStatus?>? workStatus,
      Value<EventTaskType?>? type,
      Value<String?>? projectName,
      Value<String?>? companyPhoto,
      Value<String?>? companyName,
      Value<String?>? storeName,
      Value<String?>? doneTime,
      Value<DateTime?>? dateLocal,
      Value<String?>? status,
      Value<String?>? scopeName,
      Value<String?>? clientName,
      Value<String?>? leaderName,
      Value<EventPageType?>? pageType,
      Value<int?>? sort,
      Value<bool?>? showEndDate,
      Value<int>? rowid}) {
    return EventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectStartDate: projectStartDate ?? this.projectStartDate,
      projectEndDate: projectEndDate ?? this.projectEndDate,
      comment: comment ?? this.comment,
      repeat: repeat ?? this.repeat,
      alarm: alarm ?? this.alarm,
      place: place ?? this.place,
      busyMode: busyMode ?? this.busyMode,
      creator: creator ?? this.creator,
      users: users ?? this.users,
      waitingToConfirm: waitingToConfirm ?? this.waitingToConfirm,
      eventStatus: eventStatus ?? this.eventStatus,
      workStatus: workStatus ?? this.workStatus,
      type: type ?? this.type,
      projectName: projectName ?? this.projectName,
      companyPhoto: companyPhoto ?? this.companyPhoto,
      companyName: companyName ?? this.companyName,
      storeName: storeName ?? this.storeName,
      doneTime: doneTime ?? this.doneTime,
      dateLocal: dateLocal ?? this.dateLocal,
      status: status ?? this.status,
      scopeName: scopeName ?? this.scopeName,
      clientName: clientName ?? this.clientName,
      leaderName: leaderName ?? this.leaderName,
      pageType: pageType ?? this.pageType,
      sort: sort ?? this.sort,
      showEndDate: showEndDate ?? this.showEndDate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<String>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<String>(endDate.value);
    }
    if (projectStartDate.present) {
      map['project_start_date'] = Variable<String>(projectStartDate.value);
    }
    if (projectEndDate.present) {
      map['project_end_date'] = Variable<String>(projectEndDate.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (alarm.present) {
      map['alarm'] = Variable<String>(alarm.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (busyMode.present) {
      map['busy_mode'] = Variable<int>(busyMode.value);
    }
    if (creator.present) {
      final converter = $EventsTable.$convertercreatorn;

      map['creator'] = Variable<String>(converter.toSql(creator.value));
    }
    if (users.present) {
      final converter = $EventsTable.$converterusersn;

      map['users'] = Variable<String>(converter.toSql(users.value));
    }
    if (waitingToConfirm.present) {
      map['waiting_to_confirm'] = Variable<bool>(waitingToConfirm.value);
    }
    if (eventStatus.present) {
      final converter = $EventsTable.$convertereventStatusn;

      map['event_status'] =
          Variable<String>(converter.toSql(eventStatus.value));
    }
    if (workStatus.present) {
      final converter = $EventsTable.$converterworkStatusn;

      map['work_status'] = Variable<String>(converter.toSql(workStatus.value));
    }
    if (type.present) {
      final converter = $EventsTable.$convertertypen;

      map['type'] = Variable<String>(converter.toSql(type.value));
    }
    if (projectName.present) {
      map['project_name'] = Variable<String>(projectName.value);
    }
    if (companyPhoto.present) {
      map['company_photo'] = Variable<String>(companyPhoto.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (storeName.present) {
      map['store_name'] = Variable<String>(storeName.value);
    }
    if (doneTime.present) {
      map['done_time'] = Variable<String>(doneTime.value);
    }
    if (dateLocal.present) {
      map['date_local'] = Variable<DateTime>(dateLocal.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (scopeName.present) {
      map['scope_name'] = Variable<String>(scopeName.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (leaderName.present) {
      map['leader_name'] = Variable<String>(leaderName.value);
    }
    if (pageType.present) {
      final converter = $EventsTable.$converterpageTypen;

      map['page_type'] = Variable<String>(converter.toSql(pageType.value));
    }
    if (sort.present) {
      map['sort'] = Variable<int>(sort.value);
    }
    if (showEndDate.present) {
      map['show_end_date'] = Variable<bool>(showEndDate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('projectStartDate: $projectStartDate, ')
          ..write('projectEndDate: $projectEndDate, ')
          ..write('comment: $comment, ')
          ..write('repeat: $repeat, ')
          ..write('alarm: $alarm, ')
          ..write('place: $place, ')
          ..write('busyMode: $busyMode, ')
          ..write('creator: $creator, ')
          ..write('users: $users, ')
          ..write('waitingToConfirm: $waitingToConfirm, ')
          ..write('eventStatus: $eventStatus, ')
          ..write('workStatus: $workStatus, ')
          ..write('type: $type, ')
          ..write('projectName: $projectName, ')
          ..write('companyPhoto: $companyPhoto, ')
          ..write('companyName: $companyName, ')
          ..write('storeName: $storeName, ')
          ..write('doneTime: $doneTime, ')
          ..write('dateLocal: $dateLocal, ')
          ..write('status: $status, ')
          ..write('scopeName: $scopeName, ')
          ..write('clientName: $clientName, ')
          ..write('leaderName: $leaderName, ')
          ..write('pageType: $pageType, ')
          ..write('sort: $sort, ')
          ..write('showEndDate: $showEndDate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ContactsTable extends Contacts with TableInfo<$ContactsTable, Contact> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContactsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fullAddressMeta =
      const VerificationMeta('fullAddress');
  @override
  late final GeneratedColumn<String> fullAddress = GeneratedColumn<String>(
      'full_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthdayMeta =
      const VerificationMeta('birthday');
  @override
  late final GeneratedColumn<String> birthday = GeneratedColumn<String>(
      'birthday', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<int> gender = GeneratedColumn<int>(
      'gender', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _countryCodeMeta =
      const VerificationMeta('countryCode');
  @override
  late final GeneratedColumn<String> countryCode = GeneratedColumn<String>(
      'country_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dialCodeMeta =
      const VerificationMeta('dialCode');
  @override
  late final GeneratedColumn<String> dialCode = GeneratedColumn<String>(
      'dial_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
      'page', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _userContactIdMeta =
      const VerificationMeta('userContactId');
  @override
  late final GeneratedColumn<int> userContactId = GeneratedColumn<int>(
      'user_contact_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        email,
        fullAddress,
        birthday,
        gender,
        countryCode,
        city,
        phoneNumber,
        dialCode,
        avatar,
        page,
        userContactId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'contacts';
  @override
  VerificationContext validateIntegrity(Insertable<Contact> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('full_address')) {
      context.handle(
          _fullAddressMeta,
          fullAddress.isAcceptableOrUnknown(
              data['full_address']!, _fullAddressMeta));
    }
    if (data.containsKey('birthday')) {
      context.handle(_birthdayMeta,
          birthday.isAcceptableOrUnknown(data['birthday']!, _birthdayMeta));
    }
    if (data.containsKey('gender')) {
      context.handle(_genderMeta,
          gender.isAcceptableOrUnknown(data['gender']!, _genderMeta));
    }
    if (data.containsKey('country_code')) {
      context.handle(
          _countryCodeMeta,
          countryCode.isAcceptableOrUnknown(
              data['country_code']!, _countryCodeMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    }
    if (data.containsKey('dial_code')) {
      context.handle(_dialCodeMeta,
          dialCode.isAcceptableOrUnknown(data['dial_code']!, _dialCodeMeta));
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('page')) {
      context.handle(
          _pageMeta, page.isAcceptableOrUnknown(data['page']!, _pageMeta));
    }
    if (data.containsKey('user_contact_id')) {
      context.handle(
          _userContactIdMeta,
          userContactId.isAcceptableOrUnknown(
              data['user_contact_id']!, _userContactIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Contact map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Contact(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      fullAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_address']),
      birthday: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birthday']),
      gender: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}gender']),
      countryCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country_code']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number']),
      dialCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dial_code']),
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      page: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page']),
      userContactId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_contact_id']),
    );
  }

  @override
  $ContactsTable createAlias(String alias) {
    return $ContactsTable(attachedDatabase, alias);
  }
}

class Contact extends DataClass implements Insertable<Contact> {
  int id;
  String? name;
  String? email;
  String? fullAddress;
  String? birthday;
  int? gender;
  String? countryCode;
  String? city;
  String? phoneNumber;
  String? dialCode;
  String? avatar;
  int? page;
  int? userContactId;
  Contact(
      {required this.id,
      this.name,
      this.email,
      this.fullAddress,
      this.birthday,
      this.gender,
      this.countryCode,
      this.city,
      this.phoneNumber,
      this.dialCode,
      this.avatar,
      this.page,
      this.userContactId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || fullAddress != null) {
      map['full_address'] = Variable<String>(fullAddress);
    }
    if (!nullToAbsent || birthday != null) {
      map['birthday'] = Variable<String>(birthday);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<int>(gender);
    }
    if (!nullToAbsent || countryCode != null) {
      map['country_code'] = Variable<String>(countryCode);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || dialCode != null) {
      map['dial_code'] = Variable<String>(dialCode);
    }
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || page != null) {
      map['page'] = Variable<int>(page);
    }
    if (!nullToAbsent || userContactId != null) {
      map['user_contact_id'] = Variable<int>(userContactId);
    }
    return map;
  }

  ContactsCompanion toCompanion(bool nullToAbsent) {
    return ContactsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      fullAddress: fullAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(fullAddress),
      birthday: birthday == null && nullToAbsent
          ? const Value.absent()
          : Value(birthday),
      gender:
          gender == null && nullToAbsent ? const Value.absent() : Value(gender),
      countryCode: countryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(countryCode),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      dialCode: dialCode == null && nullToAbsent
          ? const Value.absent()
          : Value(dialCode),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      page: page == null && nullToAbsent ? const Value.absent() : Value(page),
      userContactId: userContactId == null && nullToAbsent
          ? const Value.absent()
          : Value(userContactId),
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Contact(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      fullAddress: serializer.fromJson<String?>(json['full_address']),
      birthday: serializer.fromJson<String?>(json['birthday']),
      gender: serializer.fromJson<int?>(json['gender']),
      countryCode: serializer.fromJson<String?>(json['country_code']),
      city: serializer.fromJson<String?>(json['city']),
      phoneNumber: serializer.fromJson<String?>(json['phone_number']),
      dialCode: serializer.fromJson<String?>(json['dial_code']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      page: serializer.fromJson<int?>(json['page']),
      userContactId: serializer.fromJson<int?>(json['user_contact_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'email': serializer.toJson<String?>(email),
      'full_address': serializer.toJson<String?>(fullAddress),
      'birthday': serializer.toJson<String?>(birthday),
      'gender': serializer.toJson<int?>(gender),
      'country_code': serializer.toJson<String?>(countryCode),
      'city': serializer.toJson<String?>(city),
      'phone_number': serializer.toJson<String?>(phoneNumber),
      'dial_code': serializer.toJson<String?>(dialCode),
      'avatar': serializer.toJson<String?>(avatar),
      'page': serializer.toJson<int?>(page),
      'user_contact_id': serializer.toJson<int?>(userContactId),
    };
  }

  Contact copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> fullAddress = const Value.absent(),
          Value<String?> birthday = const Value.absent(),
          Value<int?> gender = const Value.absent(),
          Value<String?> countryCode = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> phoneNumber = const Value.absent(),
          Value<String?> dialCode = const Value.absent(),
          Value<String?> avatar = const Value.absent(),
          Value<int?> page = const Value.absent(),
          Value<int?> userContactId = const Value.absent()}) =>
      Contact(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        email: email.present ? email.value : this.email,
        fullAddress: fullAddress.present ? fullAddress.value : this.fullAddress,
        birthday: birthday.present ? birthday.value : this.birthday,
        gender: gender.present ? gender.value : this.gender,
        countryCode: countryCode.present ? countryCode.value : this.countryCode,
        city: city.present ? city.value : this.city,
        phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
        dialCode: dialCode.present ? dialCode.value : this.dialCode,
        avatar: avatar.present ? avatar.value : this.avatar,
        page: page.present ? page.value : this.page,
        userContactId:
            userContactId.present ? userContactId.value : this.userContactId,
      );
  @override
  String toString() {
    return (StringBuffer('Contact(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('fullAddress: $fullAddress, ')
          ..write('birthday: $birthday, ')
          ..write('gender: $gender, ')
          ..write('countryCode: $countryCode, ')
          ..write('city: $city, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('dialCode: $dialCode, ')
          ..write('avatar: $avatar, ')
          ..write('page: $page, ')
          ..write('userContactId: $userContactId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      email,
      fullAddress,
      birthday,
      gender,
      countryCode,
      city,
      phoneNumber,
      dialCode,
      avatar,
      page,
      userContactId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Contact &&
          other.id == this.id &&
          other.name == this.name &&
          other.email == this.email &&
          other.fullAddress == this.fullAddress &&
          other.birthday == this.birthday &&
          other.gender == this.gender &&
          other.countryCode == this.countryCode &&
          other.city == this.city &&
          other.phoneNumber == this.phoneNumber &&
          other.dialCode == this.dialCode &&
          other.avatar == this.avatar &&
          other.page == this.page &&
          other.userContactId == this.userContactId);
}

class ContactsCompanion extends UpdateCompanion<Contact> {
  Value<int> id;
  Value<String?> name;
  Value<String?> email;
  Value<String?> fullAddress;
  Value<String?> birthday;
  Value<int?> gender;
  Value<String?> countryCode;
  Value<String?> city;
  Value<String?> phoneNumber;
  Value<String?> dialCode;
  Value<String?> avatar;
  Value<int?> page;
  Value<int?> userContactId;
  ContactsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.fullAddress = const Value.absent(),
    this.birthday = const Value.absent(),
    this.gender = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.city = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.dialCode = const Value.absent(),
    this.avatar = const Value.absent(),
    this.page = const Value.absent(),
    this.userContactId = const Value.absent(),
  });
  ContactsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.fullAddress = const Value.absent(),
    this.birthday = const Value.absent(),
    this.gender = const Value.absent(),
    this.countryCode = const Value.absent(),
    this.city = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.dialCode = const Value.absent(),
    this.avatar = const Value.absent(),
    this.page = const Value.absent(),
    this.userContactId = const Value.absent(),
  });
  static Insertable<Contact> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? email,
    Expression<String>? fullAddress,
    Expression<String>? birthday,
    Expression<int>? gender,
    Expression<String>? countryCode,
    Expression<String>? city,
    Expression<String>? phoneNumber,
    Expression<String>? dialCode,
    Expression<String>? avatar,
    Expression<int>? page,
    Expression<int>? userContactId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (fullAddress != null) 'full_address': fullAddress,
      if (birthday != null) 'birthday': birthday,
      if (gender != null) 'gender': gender,
      if (countryCode != null) 'country_code': countryCode,
      if (city != null) 'city': city,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (dialCode != null) 'dial_code': dialCode,
      if (avatar != null) 'avatar': avatar,
      if (page != null) 'page': page,
      if (userContactId != null) 'user_contact_id': userContactId,
    });
  }

  ContactsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? email,
      Value<String?>? fullAddress,
      Value<String?>? birthday,
      Value<int?>? gender,
      Value<String?>? countryCode,
      Value<String?>? city,
      Value<String?>? phoneNumber,
      Value<String?>? dialCode,
      Value<String?>? avatar,
      Value<int?>? page,
      Value<int?>? userContactId}) {
    return ContactsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      fullAddress: fullAddress ?? this.fullAddress,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      countryCode: countryCode ?? this.countryCode,
      city: city ?? this.city,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dialCode: dialCode ?? this.dialCode,
      avatar: avatar ?? this.avatar,
      page: page ?? this.page,
      userContactId: userContactId ?? this.userContactId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (fullAddress.present) {
      map['full_address'] = Variable<String>(fullAddress.value);
    }
    if (birthday.present) {
      map['birthday'] = Variable<String>(birthday.value);
    }
    if (gender.present) {
      map['gender'] = Variable<int>(gender.value);
    }
    if (countryCode.present) {
      map['country_code'] = Variable<String>(countryCode.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (dialCode.present) {
      map['dial_code'] = Variable<String>(dialCode.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (userContactId.present) {
      map['user_contact_id'] = Variable<int>(userContactId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContactsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('fullAddress: $fullAddress, ')
          ..write('birthday: $birthday, ')
          ..write('gender: $gender, ')
          ..write('countryCode: $countryCode, ')
          ..write('city: $city, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('dialCode: $dialCode, ')
          ..write('avatar: $avatar, ')
          ..write('page: $page, ')
          ..write('userContactId: $userContactId')
          ..write(')'))
        .toString();
  }
}

class $EventChecksTable extends EventChecks
    with TableInfo<$EventChecksTable, EventCheck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventChecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_checks';
  @override
  VerificationContext validateIntegrity(Insertable<EventCheck> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  EventCheck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventCheck(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value']),
    );
  }

  @override
  $EventChecksTable createAlias(String alias) {
    return $EventChecksTable(attachedDatabase, alias);
  }
}

class EventCheck extends DataClass implements Insertable<EventCheck> {
  String key;
  String? value;
  EventCheck({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  EventChecksCompanion toCompanion(bool nullToAbsent) {
    return EventChecksCompanion(
      key: Value(key),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory EventCheck.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventCheck(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  EventCheck copyWith(
          {String? key, Value<String?> value = const Value.absent()}) =>
      EventCheck(
        key: key ?? this.key,
        value: value.present ? value.value : this.value,
      );
  @override
  String toString() {
    return (StringBuffer('EventCheck(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventCheck &&
          other.key == this.key &&
          other.value == this.value);
}

class EventChecksCompanion extends UpdateCompanion<EventCheck> {
  Value<String> key;
  Value<String?> value;
  Value<int> rowid;
  EventChecksCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventChecksCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<EventCheck> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventChecksCompanion copyWith(
      {Value<String>? key, Value<String?>? value, Value<int>? rowid}) {
    return EventChecksCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventChecksCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CorpsTable extends Corps with TableInfo<$CorpsTable, Corp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CorpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logoMeta = const VerificationMeta('logo');
  @override
  late final GeneratedColumn<String> logo = GeneratedColumn<String>(
      'logo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleNameMeta =
      const VerificationMeta('roleName');
  @override
  late final GeneratedColumn<String> roleName = GeneratedColumn<String>(
      'role_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _confirmedMeta =
      const VerificationMeta('confirmed');
  @override
  late final GeneratedColumn<bool> confirmed = GeneratedColumn<bool>(
      'confirmed', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("confirmed" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [id, name, logo, roleName, confirmed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'corps';
  @override
  VerificationContext validateIntegrity(Insertable<Corp> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('logo')) {
      context.handle(
          _logoMeta, logo.isAcceptableOrUnknown(data['logo']!, _logoMeta));
    }
    if (data.containsKey('role_name')) {
      context.handle(_roleNameMeta,
          roleName.isAcceptableOrUnknown(data['role_name']!, _roleNameMeta));
    }
    if (data.containsKey('confirmed')) {
      context.handle(_confirmedMeta,
          confirmed.isAcceptableOrUnknown(data['confirmed']!, _confirmedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Corp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Corp(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      logo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logo']),
      roleName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role_name']),
      confirmed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}confirmed']),
    );
  }

  @override
  $CorpsTable createAlias(String alias) {
    return $CorpsTable(attachedDatabase, alias);
  }
}

class Corp extends DataClass implements Insertable<Corp> {
  int id;
  String? name;
  String? logo;
  String? roleName;
  bool? confirmed;
  Corp({required this.id, this.name, this.logo, this.roleName, this.confirmed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || logo != null) {
      map['logo'] = Variable<String>(logo);
    }
    if (!nullToAbsent || roleName != null) {
      map['role_name'] = Variable<String>(roleName);
    }
    if (!nullToAbsent || confirmed != null) {
      map['confirmed'] = Variable<bool>(confirmed);
    }
    return map;
  }

  CorpsCompanion toCompanion(bool nullToAbsent) {
    return CorpsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      logo: logo == null && nullToAbsent ? const Value.absent() : Value(logo),
      roleName: roleName == null && nullToAbsent
          ? const Value.absent()
          : Value(roleName),
      confirmed: confirmed == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmed),
    );
  }

  factory Corp.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Corp(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      logo: serializer.fromJson<String?>(json['logo']),
      roleName: serializer.fromJson<String?>(json['role_name']),
      confirmed: serializer.fromJson<bool?>(json['confirmed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'logo': serializer.toJson<String?>(logo),
      'role_name': serializer.toJson<String?>(roleName),
      'confirmed': serializer.toJson<bool?>(confirmed),
    };
  }

  Corp copyWith(
          {int? id,
          Value<String?> name = const Value.absent(),
          Value<String?> logo = const Value.absent(),
          Value<String?> roleName = const Value.absent(),
          Value<bool?> confirmed = const Value.absent()}) =>
      Corp(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        logo: logo.present ? logo.value : this.logo,
        roleName: roleName.present ? roleName.value : this.roleName,
        confirmed: confirmed.present ? confirmed.value : this.confirmed,
      );
  @override
  String toString() {
    return (StringBuffer('Corp(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logo: $logo, ')
          ..write('roleName: $roleName, ')
          ..write('confirmed: $confirmed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, logo, roleName, confirmed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Corp &&
          other.id == this.id &&
          other.name == this.name &&
          other.logo == this.logo &&
          other.roleName == this.roleName &&
          other.confirmed == this.confirmed);
}

class CorpsCompanion extends UpdateCompanion<Corp> {
  Value<int> id;
  Value<String?> name;
  Value<String?> logo;
  Value<String?> roleName;
  Value<bool?> confirmed;
  CorpsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.logo = const Value.absent(),
    this.roleName = const Value.absent(),
    this.confirmed = const Value.absent(),
  });
  CorpsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.logo = const Value.absent(),
    this.roleName = const Value.absent(),
    this.confirmed = const Value.absent(),
  });
  static Insertable<Corp> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? logo,
    Expression<String>? roleName,
    Expression<bool>? confirmed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (logo != null) 'logo': logo,
      if (roleName != null) 'role_name': roleName,
      if (confirmed != null) 'confirmed': confirmed,
    });
  }

  CorpsCompanion copyWith(
      {Value<int>? id,
      Value<String?>? name,
      Value<String?>? logo,
      Value<String?>? roleName,
      Value<bool?>? confirmed}) {
    return CorpsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      logo: logo ?? this.logo,
      roleName: roleName ?? this.roleName,
      confirmed: confirmed ?? this.confirmed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (logo.present) {
      map['logo'] = Variable<String>(logo.value);
    }
    if (roleName.present) {
      map['role_name'] = Variable<String>(roleName.value);
    }
    if (confirmed.present) {
      map['confirmed'] = Variable<bool>(confirmed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CorpsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('logo: $logo, ')
          ..write('roleName: $roleName, ')
          ..write('confirmed: $confirmed')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _creatorMeta =
      const VerificationMeta('creator');
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, dynamic>?, String>
      creator = GeneratedColumn<String>('creator', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<Map<String, dynamic>?>($TodosTable.$convertercreatorn);
  static const VerificationMeta _usersMeta = const VerificationMeta('users');
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>?, String> users =
      GeneratedColumn<String>('users', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<dynamic>?>($TodosTable.$converterusersn);
  static const VerificationMeta _doneTimeMeta =
      const VerificationMeta('doneTime');
  @override
  late final GeneratedColumn<String> doneTime = GeneratedColumn<String>(
      'done_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(0));
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
      'order', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _childrenMeta =
      const VerificationMeta('children');
  @override
  late final GeneratedColumnWithTypeConverter<List<dynamic>?, String> children =
      GeneratedColumn<String>('children', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<List<dynamic>?>($TodosTable.$converterchildrenn);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _updatedByMeta =
      const VerificationMeta('updatedBy');
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
      'updated_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _overlineMeta =
      const VerificationMeta('overline');
  @override
  late final GeneratedColumn<bool> overline = GeneratedColumn<bool>(
      'overline', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("overline" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        title,
        creator,
        users,
        doneTime,
        parentId,
        order,
        children,
        createdAt,
        updatedAt,
        updatedBy,
        overline
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(Insertable<Todo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    context.handle(_creatorMeta, const VerificationResult.success());
    context.handle(_usersMeta, const VerificationResult.success());
    if (data.containsKey('done_time')) {
      context.handle(_doneTimeMeta,
          doneTime.isAcceptableOrUnknown(data['done_time']!, _doneTimeMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('order')) {
      context.handle(
          _orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    context.handle(_childrenMeta, const VerificationResult.success());
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('updated_by')) {
      context.handle(_updatedByMeta,
          updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta));
    }
    if (data.containsKey('overline')) {
      context.handle(_overlineMeta,
          overline.isAcceptableOrUnknown(data['overline']!, _overlineMeta));
    } else if (isInserting) {
      context.missing(_overlineMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      creator: $TodosTable.$convertercreatorn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}creator'])),
      users: $TodosTable.$converterusersn.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}users'])),
      doneTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}done_time']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id'])!,
      order: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order']),
      children: $TodosTable.$converterchildrenn.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}children'])),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at']),
      updatedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_by']),
      overline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}overline'])!,
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }

  static TypeConverter<Map<String, dynamic>, String> $convertercreator =
      const MapConverter();
  static TypeConverter<Map<String, dynamic>?, String?> $convertercreatorn =
      NullAwareTypeConverter.wrap($convertercreator);
  static TypeConverter<List<dynamic>, String> $converterusers =
      const ListConverter();
  static TypeConverter<List<dynamic>?, String?> $converterusersn =
      NullAwareTypeConverter.wrap($converterusers);
  static TypeConverter<List<dynamic>, String> $converterchildren =
      const ListConverter();
  static TypeConverter<List<dynamic>?, String?> $converterchildrenn =
      NullAwareTypeConverter.wrap($converterchildren);
}

class Todo extends DataClass implements Insertable<Todo> {
  int id;
  String type;
  String title;
  Map<String, dynamic>? creator;
  List<dynamic>? users;
  String? doneTime;
  int parentId;
  int? order;
  List<dynamic>? children;
  String? createdAt;
  String? updatedAt;
  String? updatedBy;
  bool overline;
  Todo(
      {required this.id,
      required this.type,
      required this.title,
      this.creator,
      this.users,
      this.doneTime,
      required this.parentId,
      this.order,
      this.children,
      this.createdAt,
      this.updatedAt,
      this.updatedBy,
      required this.overline});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || creator != null) {
      final converter = $TodosTable.$convertercreatorn;
      map['creator'] = Variable<String>(converter.toSql(creator));
    }
    if (!nullToAbsent || users != null) {
      final converter = $TodosTable.$converterusersn;
      map['users'] = Variable<String>(converter.toSql(users));
    }
    if (!nullToAbsent || doneTime != null) {
      map['done_time'] = Variable<String>(doneTime);
    }
    map['parent_id'] = Variable<int>(parentId);
    if (!nullToAbsent || order != null) {
      map['order'] = Variable<int>(order);
    }
    if (!nullToAbsent || children != null) {
      final converter = $TodosTable.$converterchildrenn;
      map['children'] = Variable<String>(converter.toSql(children));
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<String>(updatedAt);
    }
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    map['overline'] = Variable<bool>(overline);
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      type: Value(type),
      title: Value(title),
      creator: creator == null && nullToAbsent
          ? const Value.absent()
          : Value(creator),
      users:
          users == null && nullToAbsent ? const Value.absent() : Value(users),
      doneTime: doneTime == null && nullToAbsent
          ? const Value.absent()
          : Value(doneTime),
      parentId: Value(parentId),
      order:
          order == null && nullToAbsent ? const Value.absent() : Value(order),
      children: children == null && nullToAbsent
          ? const Value.absent()
          : Value(children),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      overline: Value(overline),
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      creator: serializer.fromJson<Map<String, dynamic>?>(json['creator']),
      users: serializer.fromJson<List<dynamic>?>(json['users']),
      doneTime: serializer.fromJson<String?>(json['done_time']),
      parentId: serializer.fromJson<int>(json['parent_Id']),
      order: serializer.fromJson<int?>(json['order']),
      children: serializer.fromJson<List<dynamic>?>(json['children']),
      createdAt: serializer.fromJson<String?>(json['created_at']),
      updatedAt: serializer.fromJson<String?>(json['updated_at']),
      updatedBy: serializer.fromJson<String?>(json['updated_by']),
      overline: serializer.fromJson<bool>(json['overline']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'creator': serializer.toJson<Map<String, dynamic>?>(creator),
      'users': serializer.toJson<List<dynamic>?>(users),
      'done_time': serializer.toJson<String?>(doneTime),
      'parent_Id': serializer.toJson<int>(parentId),
      'order': serializer.toJson<int?>(order),
      'children': serializer.toJson<List<dynamic>?>(children),
      'created_at': serializer.toJson<String?>(createdAt),
      'updated_at': serializer.toJson<String?>(updatedAt),
      'updated_by': serializer.toJson<String?>(updatedBy),
      'overline': serializer.toJson<bool>(overline),
    };
  }

  Todo copyWith(
          {int? id,
          String? type,
          String? title,
          Value<Map<String, dynamic>?> creator = const Value.absent(),
          Value<List<dynamic>?> users = const Value.absent(),
          Value<String?> doneTime = const Value.absent(),
          int? parentId,
          Value<int?> order = const Value.absent(),
          Value<List<dynamic>?> children = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> updatedAt = const Value.absent(),
          Value<String?> updatedBy = const Value.absent(),
          bool? overline}) =>
      Todo(
        id: id ?? this.id,
        type: type ?? this.type,
        title: title ?? this.title,
        creator: creator.present ? creator.value : this.creator,
        users: users.present ? users.value : this.users,
        doneTime: doneTime.present ? doneTime.value : this.doneTime,
        parentId: parentId ?? this.parentId,
        order: order.present ? order.value : this.order,
        children: children.present ? children.value : this.children,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
        overline: overline ?? this.overline,
      );
  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('creator: $creator, ')
          ..write('users: $users, ')
          ..write('doneTime: $doneTime, ')
          ..write('parentId: $parentId, ')
          ..write('order: $order, ')
          ..write('children: $children, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('overline: $overline')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, title, creator, users, doneTime,
      parentId, order, children, createdAt, updatedAt, updatedBy, overline);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.type == this.type &&
          other.title == this.title &&
          other.creator == this.creator &&
          other.users == this.users &&
          other.doneTime == this.doneTime &&
          other.parentId == this.parentId &&
          other.order == this.order &&
          other.children == this.children &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.overline == this.overline);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  Value<int> id;
  Value<String> type;
  Value<String> title;
  Value<Map<String, dynamic>?> creator;
  Value<List<dynamic>?> users;
  Value<String?> doneTime;
  Value<int> parentId;
  Value<int?> order;
  Value<List<dynamic>?> children;
  Value<String?> createdAt;
  Value<String?> updatedAt;
  Value<String?> updatedBy;
  Value<bool> overline;
  TodosCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.creator = const Value.absent(),
    this.users = const Value.absent(),
    this.doneTime = const Value.absent(),
    this.parentId = const Value.absent(),
    this.order = const Value.absent(),
    this.children = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.overline = const Value.absent(),
  });
  TodosCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String title,
    this.creator = const Value.absent(),
    this.users = const Value.absent(),
    this.doneTime = const Value.absent(),
    this.parentId = const Value.absent(),
    this.order = const Value.absent(),
    this.children = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    required bool overline,
  })  : type = Value(type),
        title = Value(title),
        overline = Value(overline);
  static Insertable<Todo> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? creator,
    Expression<String>? users,
    Expression<String>? doneTime,
    Expression<int>? parentId,
    Expression<int>? order,
    Expression<String>? children,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? updatedBy,
    Expression<bool>? overline,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (creator != null) 'creator': creator,
      if (users != null) 'users': users,
      if (doneTime != null) 'done_time': doneTime,
      if (parentId != null) 'parent_id': parentId,
      if (order != null) 'order': order,
      if (children != null) 'children': children,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (overline != null) 'overline': overline,
    });
  }

  TodosCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? title,
      Value<Map<String, dynamic>?>? creator,
      Value<List<dynamic>?>? users,
      Value<String?>? doneTime,
      Value<int>? parentId,
      Value<int?>? order,
      Value<List<dynamic>?>? children,
      Value<String?>? createdAt,
      Value<String?>? updatedAt,
      Value<String?>? updatedBy,
      Value<bool>? overline}) {
    return TodosCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      creator: creator ?? this.creator,
      users: users ?? this.users,
      doneTime: doneTime ?? this.doneTime,
      parentId: parentId ?? this.parentId,
      order: order ?? this.order,
      children: children ?? this.children,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      overline: overline ?? this.overline,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (creator.present) {
      final converter = $TodosTable.$convertercreatorn;

      map['creator'] = Variable<String>(converter.toSql(creator.value));
    }
    if (users.present) {
      final converter = $TodosTable.$converterusersn;

      map['users'] = Variable<String>(converter.toSql(users.value));
    }
    if (doneTime.present) {
      map['done_time'] = Variable<String>(doneTime.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (children.present) {
      final converter = $TodosTable.$converterchildrenn;

      map['children'] = Variable<String>(converter.toSql(children.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (overline.present) {
      map['overline'] = Variable<bool>(overline.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('creator: $creator, ')
          ..write('users: $users, ')
          ..write('doneTime: $doneTime, ')
          ..write('parentId: $parentId, ')
          ..write('order: $order, ')
          ..write('children: $children, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('overline: $overline')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, Notification> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant('personal'));
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<String> readAt = GeneratedColumn<String>(
      'read_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timeAgoMeta =
      const VerificationMeta('timeAgo');
  @override
  late final GeneratedColumn<String> timeAgo = GeneratedColumn<String>(
      'time_ago', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routeNameMeta =
      const VerificationMeta('routeName');
  @override
  late final GeneratedColumn<String> routeName = GeneratedColumn<String>(
      'route_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _argumentsMeta =
      const VerificationMeta('arguments');
  @override
  late final GeneratedColumn<String> arguments = GeneratedColumn<String>(
      'arguments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        action,
        avatar,
        title,
        body,
        type,
        readAt,
        timeAgo,
        createdAt,
        updatedAt,
        routeName,
        arguments
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(Insertable<Notification> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    }
    if (data.containsKey('time_ago')) {
      context.handle(_timeAgoMeta,
          timeAgo.isAcceptableOrUnknown(data['time_ago']!, _timeAgoMeta));
    } else if (isInserting) {
      context.missing(_timeAgoMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('route_name')) {
      context.handle(_routeNameMeta,
          routeName.isAcceptableOrUnknown(data['route_name']!, _routeNameMeta));
    }
    if (data.containsKey('arguments')) {
      context.handle(_argumentsMeta,
          arguments.isAcceptableOrUnknown(data['arguments']!, _argumentsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notification map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notification(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}read_at']),
      timeAgo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time_ago'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      routeName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}route_name']),
      arguments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}arguments']),
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class Notification extends DataClass implements Insertable<Notification> {
  String id;
  String action;
  String? avatar;
  String title;
  String body;
  String type;
  String? readAt;
  String timeAgo;
  String createdAt;
  String updatedAt;
  String? routeName;
  String? arguments;
  Notification(
      {required this.id,
      required this.action,
      this.avatar,
      required this.title,
      required this.body,
      required this.type,
      this.readAt,
      required this.timeAgo,
      required this.createdAt,
      required this.updatedAt,
      this.routeName,
      this.arguments});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<String>(readAt);
    }
    map['time_ago'] = Variable<String>(timeAgo);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || routeName != null) {
      map['route_name'] = Variable<String>(routeName);
    }
    if (!nullToAbsent || arguments != null) {
      map['arguments'] = Variable<String>(arguments);
    }
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      action: Value(action),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      title: Value(title),
      body: Value(body),
      type: Value(type),
      readAt:
          readAt == null && nullToAbsent ? const Value.absent() : Value(readAt),
      timeAgo: Value(timeAgo),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      routeName: routeName == null && nullToAbsent
          ? const Value.absent()
          : Value(routeName),
      arguments: arguments == null && nullToAbsent
          ? const Value.absent()
          : Value(arguments),
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notification(
      id: serializer.fromJson<String>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      type: serializer.fromJson<String>(json['type']),
      readAt: serializer.fromJson<String?>(json['read_at']),
      timeAgo: serializer.fromJson<String>(json['time_ago']),
      createdAt: serializer.fromJson<String>(json['created_at']),
      updatedAt: serializer.fromJson<String>(json['updated_at']),
      routeName: serializer.fromJson<String?>(json['route_name']),
      arguments: serializer.fromJson<String?>(json['arguments']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'action': serializer.toJson<String>(action),
      'avatar': serializer.toJson<String?>(avatar),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'type': serializer.toJson<String>(type),
      'read_at': serializer.toJson<String?>(readAt),
      'time_ago': serializer.toJson<String>(timeAgo),
      'created_at': serializer.toJson<String>(createdAt),
      'updated_at': serializer.toJson<String>(updatedAt),
      'route_name': serializer.toJson<String?>(routeName),
      'arguments': serializer.toJson<String?>(arguments),
    };
  }

  Notification copyWith(
          {String? id,
          String? action,
          Value<String?> avatar = const Value.absent(),
          String? title,
          String? body,
          String? type,
          Value<String?> readAt = const Value.absent(),
          String? timeAgo,
          String? createdAt,
          String? updatedAt,
          Value<String?> routeName = const Value.absent(),
          Value<String?> arguments = const Value.absent()}) =>
      Notification(
        id: id ?? this.id,
        action: action ?? this.action,
        avatar: avatar.present ? avatar.value : this.avatar,
        title: title ?? this.title,
        body: body ?? this.body,
        type: type ?? this.type,
        readAt: readAt.present ? readAt.value : this.readAt,
        timeAgo: timeAgo ?? this.timeAgo,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        routeName: routeName.present ? routeName.value : this.routeName,
        arguments: arguments.present ? arguments.value : this.arguments,
      );
  @override
  String toString() {
    return (StringBuffer('Notification(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('avatar: $avatar, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('readAt: $readAt, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('routeName: $routeName, ')
          ..write('arguments: $arguments')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, action, avatar, title, body, type, readAt,
      timeAgo, createdAt, updatedAt, routeName, arguments);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notification &&
          other.id == this.id &&
          other.action == this.action &&
          other.avatar == this.avatar &&
          other.title == this.title &&
          other.body == this.body &&
          other.type == this.type &&
          other.readAt == this.readAt &&
          other.timeAgo == this.timeAgo &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.routeName == this.routeName &&
          other.arguments == this.arguments);
}

class NotificationsCompanion extends UpdateCompanion<Notification> {
  Value<String> id;
  Value<String> action;
  Value<String?> avatar;
  Value<String> title;
  Value<String> body;
  Value<String> type;
  Value<String?> readAt;
  Value<String> timeAgo;
  Value<String> createdAt;
  Value<String> updatedAt;
  Value<String?> routeName;
  Value<String?> arguments;
  Value<int> rowid;
  NotificationsCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.avatar = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.type = const Value.absent(),
    this.readAt = const Value.absent(),
    this.timeAgo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.routeName = const Value.absent(),
    this.arguments = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String id,
    required String action,
    this.avatar = const Value.absent(),
    required String title,
    required String body,
    this.type = const Value.absent(),
    this.readAt = const Value.absent(),
    required String timeAgo,
    required String createdAt,
    required String updatedAt,
    this.routeName = const Value.absent(),
    this.arguments = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        action = Value(action),
        title = Value(title),
        body = Value(body),
        timeAgo = Value(timeAgo),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Notification> custom({
    Expression<String>? id,
    Expression<String>? action,
    Expression<String>? avatar,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? type,
    Expression<String>? readAt,
    Expression<String>? timeAgo,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<String>? routeName,
    Expression<String>? arguments,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (avatar != null) 'avatar': avatar,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (type != null) 'type': type,
      if (readAt != null) 'read_at': readAt,
      if (timeAgo != null) 'time_ago': timeAgo,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (routeName != null) 'route_name': routeName,
      if (arguments != null) 'arguments': arguments,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? action,
      Value<String?>? avatar,
      Value<String>? title,
      Value<String>? body,
      Value<String>? type,
      Value<String?>? readAt,
      Value<String>? timeAgo,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<String?>? routeName,
      Value<String?>? arguments,
      Value<int>? rowid}) {
    return NotificationsCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      readAt: readAt ?? this.readAt,
      timeAgo: timeAgo ?? this.timeAgo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      routeName: routeName ?? this.routeName,
      arguments: arguments ?? this.arguments,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<String>(readAt.value);
    }
    if (timeAgo.present) {
      map['time_ago'] = Variable<String>(timeAgo.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (routeName.present) {
      map['route_name'] = Variable<String>(routeName.value);
    }
    if (arguments.present) {
      map['arguments'] = Variable<String>(arguments.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('avatar: $avatar, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('type: $type, ')
          ..write('readAt: $readAt, ')
          ..write('timeAgo: $timeAgo, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('routeName: $routeName, ')
          ..write('arguments: $arguments, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $EventsTable events = $EventsTable(this);
  late final $ContactsTable contacts = $ContactsTable(this);
  late final $EventChecksTable eventChecks = $EventChecksTable(this);
  late final $CorpsTable corps = $CorpsTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final EventDao eventDao = EventDao(this as AppDatabase);
  late final ContactDao contactDao = ContactDao(this as AppDatabase);
  late final EventCheckDao eventCheckDao = EventCheckDao(this as AppDatabase);
  late final CorpDao corpDao = CorpDao(this as AppDatabase);
  late final TodoDao todoDao = TodoDao(this as AppDatabase);
  late final NotificationDao notificationDao =
      NotificationDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [events, contacts, eventChecks, corps, todos, notifications];
}
