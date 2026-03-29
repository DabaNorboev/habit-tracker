import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import '../theme/app_theme.dart';
import '../services/notification_service.dart';

class CreateHabitScreen extends ConsumerStatefulWidget {
  final Function() onHabitCreated;

  const CreateHabitScreen({
    Key? key,
    required this.onHabitCreated,
  }) : super(key: key);

  @override
  ConsumerState<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends ConsumerState<CreateHabitScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPeriod = 'week';
  String _selectedEmoji = '🎯';
  final Map<String, bool> _selectedDays = {
    'Mon': false,
    'Tue': false,
    'Wed': false,
    'Thu': false,
    'Fri': false,
    'Sat': false,
    'Sun': false,
  };

  final List<String> _emojis = [
    '🎯',
    '💪',
    '🏃',
    '📚',
    '🧘',
    '💤',
    '🍎',
    '💧',
    '🚴',
    '⛹️',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.darkCardBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              // Drag indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.disabledGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Заголовок
              const Text(
                'Создать привычку',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 20),

              // Выбор эмодзи
              const Text(
                'Эмодзи',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _emojis.map((emoji) {
                  final isSelected = _selectedEmoji == emoji;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEmoji = emoji;
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryGreen
                            : AppTheme.darkBackground,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryGreen
                              : AppTheme.disabledGray,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(emoji, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Название
              const Text(
                'Название',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Например: Зарядка',
                  filled: true,
                  fillColor: AppTheme.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.disabledGray,
                    ),
                  ),
                ),
                style: const TextStyle(color: AppTheme.lightText),
              ),
              const SizedBox(height: 16),

              // Описание (необязательное)
              const Text(
                'Описание (необязательно)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Добавь детали',
                  filled: true,
                  fillColor: AppTheme.darkBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppTheme.disabledGray,
                    ),
                  ),
                ),
                style: const TextStyle(color: AppTheme.lightText),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Период
              const Text(
                'Период',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightText,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = 'week';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == 'week'
                              ? AppTheme.primaryGreen
                              : AppTheme.darkBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPeriod == 'week'
                                ? AppTheme.primaryGreen
                                : AppTheme.disabledGray,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Неделя',
                            style: TextStyle(
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = 'month';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == 'month'
                              ? AppTheme.primaryGreen
                              : AppTheme.darkBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPeriod == 'month'
                                ? AppTheme.primaryGreen
                                : AppTheme.disabledGray,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'Месяц',
                            style: TextStyle(
                              color: AppTheme.lightText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Дни недели
              if (_selectedPeriod == 'week')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Дни выполнения',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.lightText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: _selectedDays.entries.map((entry) {
                        final dayLabel = {
                          'Mon': 'Пн',
                          'Tue': 'Вт',
                          'Wed': 'Ср',
                          'Thu': 'Чт',
                          'Fri': 'Пт',
                          'Sat': 'Сб',
                          'Sun': 'Вс',
                        }[entry.key]!;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDays[entry.key] = !entry.value;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: entry.value
                                  ? AppTheme.primaryGreen
                                  : AppTheme.darkBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: entry.value
                                    ? AppTheme.primaryGreen
                                    : AppTheme.disabledGray,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                dayLabel,
                                style: const TextStyle(
                                  color: AppTheme.lightText,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              // Кнопка сохранения
              ElevatedButton(
                onPressed: _createHabit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Создать',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightText,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Отмена',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _createHabit() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название привычки')),
      );
      return;
    }

    final selectedDaysList = _selectedDays.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedDaysList.isEmpty && _selectedPeriod == 'week') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите хотя бы один день')),
      );
      return;
    }

    try {
      await ref.read(habitsProvider.notifier).addHabit(
        name: _nameController.text,
        emoji: _selectedEmoji,
        period: _selectedPeriod,
        scheduledDays:
            _selectedPeriod == 'week' ? selectedDaysList : _getAllDays(),
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
      );

      // Запланировать уведомление на 20:00
      await NotificationService().scheduleHabitReminder(
        habitName: _nameController.text,
        habitId: _nameController.text.hashCode,
      );

      widget.onHabitCreated();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  List<String> _getAllDays() {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }
}
