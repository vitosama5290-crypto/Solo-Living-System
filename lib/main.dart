import 'dart:convert';
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#030817">

<title>SON-VITO | PLAYER SYSTEM</title>

<style>
:root {
  --blue: #00bfff;
  --light-blue: #8ceaff;
  --dark: #030817;
  --panel: rgba(5, 25, 48, 0.90);
  --border: #087da9;
}

* {
  box-sizing: border-box;
}

body {
  margin: 0;
  min-height: 100vh;
  background:
    radial-gradient(ellipse at top, #092747 0%, #030817 55%),
    #030817;
  color: #d9f8ff;
  font-family: Arial, sans-serif;
}

header {
  padding: 24px 14px;
  text-align: center;
  border-bottom: 1px solid var(--border);
  background: rgba(0, 10, 25, .8);
  box-shadow: 0 0 25px #0077ff33;
}

.logo {
  color: var(--light-blue);
  font-size: 29px;
  font-weight: bold;
  letter-spacing: 3px;
  text-shadow: 0 0 15px var(--blue);
}

.subtitle {
  color: #72b9d8;
  margin-top: 8px;
  font-size: 12px;
  letter-spacing: 2px;
}

main {
  width: min(100% - 24px, 700px);
  margin: 18px auto;
}

.panel {
  border: 1px solid var(--border);
  background: var(--panel);
  padding: 17px;
  margin-bottom: 15px;
  box-shadow: 0 0 16px #008cff18;
  clip-path: polygon(
    0 0, 95% 0, 100% 12%,
    100% 100%, 5% 100%, 0 88%
  );
}

h2 {
  font-size: 17px;
  color: var(--light-blue);
  margin-top: 0;
  text-shadow: 0 0 8px #00aaff66;
}

.player-name {
  font-size: 23px;
  font-weight: bold;
  margin-bottom: 10px;
}

.rank {
  display: inline-block;
  color: #8ceaff;
  border: 1px solid var(--blue);
  padding: 5px 14px;
  margin-bottom: 12px;
  box-shadow: 0 0 10px #00bfff44;
}

.stats {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 10px;
}

.stat {
  background: #06152a;
  padding: 12px;
  border: 1px solid #124b70;
}

.stat-name {
  color: #82dfff;
  font-size: 13px;
}

.stat-value {
  font-size: 23px;
  margin-top: 6px;
  color: white;
}

.progress {
  height: 10px;
  background: #10243b;
  margin: 10px 0;
  border: 1px solid #164e76;
}

.progress-fill {
  width: 0%;
  height: 100%;
  background: linear-gradient(90deg, #0077ff, #7df4ff);
  box-shadow: 0 0 12px #00bfff;
  transition: width .4s;
}

button {
  width: 100%;
  padding: 13px 8px;
  margin-top: 9px;
  color: #dffaff;
  background: linear-gradient(100deg, #061c38, #063b60);
  border: 1px solid var(--blue);
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  transition: .2s;
}

button:hover {
  background: #075080;
  box-shadow: 0 0 15px #00bfff77;
}

button:active {
  transform: scale(.98);
}

.task {
  padding: 12px 0;
  border-bottom: 1px solid #12344d;
  line-height: 1.7;
}

.task label {
  cursor: pointer;
}

.task input {
  accent-color: #00bfff;
  width: 17px;
  height: 17px;
  vertical-align: middle;
  margin-left: 8px;
}

.reward {
  color: #74ffcc;
  font-size: 13px;
}

.notice {
  color: #8ceaff;
  line-height: 1.9;
  white-space: pre-line;
}

footer {
  text-align: center;
  color: #477b9c;
  padding: 20px 10px;
  font-size: 11px;
}

.hidden {
  display: none;
}

@media (max-width: 380px) {
  .stats {
    grid-template-columns: 1fr 1fr;
  }

  .logo {
    font-size: 24px;
  }
}
</style>
</head>

<body>

<header>
  <div class="logo">🔹 SON-VITO</div>
  <div class="subtitle">PLAYER SYSTEM • SHADOW INTERFACE</div>
</header>

<main>

  <section class="panel">
    <h2>◈ معلومات اللاعب</h2>

    <div class="player-name">SON-VITO</div>

    <div id="rank" class="rank">RANK E</div>

    <p>المستوى: <strong id="level">1</strong> / 100</p>

    <p>
      الخبرة XP:
      <strong id="xp">0</strong> /
      <strong id="requiredXp">100</strong>
    </p>

    <div class="progress">
      <div id="xpBar" class="progress-fill"></div>
    </div>

    <p>النقاط المتاحة: <strong id="points">0</strong></p>

    <button onclick="activateSystem()">تفعيل النظام</button>
    <button onclick="showTasks()">عرض المهام اليومية</button>
    <button onclick="showStats()">عرض الإحصائيات</button>
  </section>

  <section id="noticePanel" class="panel">
    <h2>◈ نافذة النظام</h2>
    <div id="notice" class="notice">
      🔹 مرحبًا أيها اللاعب.
      اضغط على «تفعيل النظام» للبدء.
    </div>
  </section>

  <section id="tasksPanel" class="panel hidden">
    <h2>◈ المهام اليومية</h2>

    <p>أكمل المهام لتحصل على نقاط الخبرة.</p>

    <div id="taskList"></div>

    <button onclick="claimTasks()">استلام XP للمهام المكتملة</button>
  </section>

  <section id="statsPanel" class="panel">
    <h2>◈ إحصائيات اللاعب</h2>

    <div class="stats">
      <div class="stat">
        <div class="stat-name">STR | القوة</div>
        <div id="str" class="stat-value">10</div>
      </div>

      <div class="stat">
        <div class="stat-name">AGI | الرشاقة</div>
        <div id="agi" class="stat-value">10</div>
      </div>

      <div class="stat">
        <div class="stat-name">VIT | التحمل</div>
        <div id="vit" class="stat-value">10</div>
      </div>

      <div class="stat">
        <div class="stat-name">INT | الذكاء</div>
        <div id="int" class="stat-value">10</div>
      </div>

      <div class="stat">
        <div class="stat-name">SEN | الإدراك</div>
        <div id="sen" class="stat-value">10</div>
      </div>
    </div>

    <button onclick="showStats()">تحديث الإحصائيات</button>
  </section>

  <section class="panel">
    <h2>◈ بوابة الغارات</h2>

    <p>اختر رتبة الغارة المناسبة لتقدمك.</p>

    <button onclick="startRaid('E')">دخول بوابة E</button>
    <button onclick="startRaid('D')">دخول بوابة D</button>
    <button onclick="startRaid('C')">دخول بوابة C</button>

    <p class="reward">
      تحذير: الغارات الأعلى رتبة أصعب.
      اختر تحديًا مناسبًا لقدرتك.
    </p>
  </section>

  <section class="panel">
    <h2>◈ المهمات السرية</h2>

    <p>اختبر الانضباط والتركيز والاستمرارية.</p>

    <button onclick="secretMission()">
      كشف المهمة السرية
    </button>
  </section>

  <section class="panel">
    <h2>◈ صندوق المكافآت</h2>

    <p>مكافآت اللاعب المكتسبة.</p>

    <div id="rewards" class="notice">
      لا توجد مكافآت مستلمة بعد.
    </div>

    <button onclick="welcomeReward()">استلام مكافأة الترحيب</button>
  </section>

</main>

<footer>
  SON-VITO SYSTEM • INSPIRED BY SOLO LEVELING
</footer>

<script>
const SAVE_KEY = "sonVitoPlayerSaveV1";

const initialState = {
  level: 1,
  xp: 0,
  points: 0,
  stats: {
    str: 10,
    agi: 10,
    vit: 10,
    int: 10,
    sen: 10
  },
  rewards: [],
  welcomeClaimed: false,
  completedTasks: [],
  claimedTasks: [],
  raids: [],
  secretClaimed: false
};

function loadState() {
  try {
    const saved = localStorage.getItem(SAVE_KEY);

    if (!saved) return structuredClone(initialState);

    const parsed = JSON.parse(saved);

    return {
      ...structuredClone(initialState),
      ...parsed,
      stats: {
        ...initialState.stats,
        ...(parsed.stats || {})
      }
    };
  } catch {
    return structuredClone(initialState);
  }
}

let state = loadState();

const tasks = [
  {
    id: "pushups",
    title: "تمارين الضغط",
    reps: "3 مجموعات مناسبة لقدرتك",
    xp: 15
  },
  {
    id: "abs",
    title: "تمارين البطن",
    reps: "3 مجموعات مناسبة لقدرتك",
    xp: 15
  },
  {
    id: "squats",
    title: "تمارين القرفصاء",
    reps: "3 مجموعات مناسبة لقدرتك",
    xp: 15
  },
  {
    id: "plank",
    title: "تمرين البلانك",
    reps: "3 جولات قصيرة مع الراحة",
    xp: 15
  },
  {
    id: "learning",
    title: "التعلم وتطوير الذكاء",
    reps: "15 دقيقة",
    xp: 10
  },
  {
    id: "discipline",
    title: "مهمة الانضباط",
    reps: "ترتيب المكان أو إنجاز مسؤولية",
    xp: 10
  }
];

function saveState() {
  localStorage.setItem(SAVE_KEY, JSON.stringify(state));
}

function requiredXP() {
  return 100 + (state.level - 1) * 25;
}

function getRank() {
  if (state.level >= 90) return "S";
  if (state.level >= 75) return "A";
  if (state.level >= 55) return "B";
  if (state.level >= 35) return "C";
  if (state.level >= 15) return "D";
  return "E";
}

function render() {
  document.getElementById("level").textContent = state.level;
  document.getElementById("xp").textContent = state.xp;
  document.getElementById("requiredXp").textContent = requiredXP();
  document.getElementById("points").textContent = state.points;
  document.getElementById("rank").textContent = "RANK " + getRank();

  const percentage = Math.min(
    100,
    (state.xp / requiredXP()) * 100
  );

  document.getElementById("xpBar").style.width =
    percentage + "%";

  for (const key of Object.keys(state.stats)) {
    document.getElementById(key).textContent =
      state.stats[key];
  }

  document.getElementById("rewards").textContent =
    state.rewards.length
      ? state.rewards.map(r => "🔹 " + r).join("\n")
      : "لا توجد مكافآت مستلمة بعد.";

  renderTasks();
}

function notify(message) {
  document.getElementById("notice").textContent = message;
}

function activateSystem() {
  notify(
    "🔹 تم تفعيل نظام SON-VITO.\n" +
    "🔹 المستوى: " + state.level + "\n" +
    "🔹 الرتبة: " + getRank() + "\n" +
    "🔹 XP: " + state.xp + "\n" +
    "🔹 النظام جاهز."
  );

  saveState();
}

function showTasks() {
  document.getElementById("tasksPanel").classList.remove("hidden");

  notify(
    "🔹 تم عرض قائمة المهام اليومية.\n" +
    "تفقد المهام دون أن تُحتسب مكتملة تلقائيًا."
  );

  renderTasks();
}

function showStats() {
  document.getElementById("statsPanel").classList.remove("hidden");

  notify(
    "🔹 إحصائيات اللاعب:\n" +
    "القوة: " + state.stats.str + "\n" +
    "الرشاقة: " + state.stats.agi + "\n" +
    "التحمل: " + state.stats.vit + "\n" +
    "الذكاء: " + state.stats.int + "\n" +
    "الإدراك: " + state.stats.sen
  );
}

function renderTasks() {
  const list = document.getElementById("taskList");

  list.innerHTML = tasks.map(task => {
    const checked = state.completedTasks.includes(task.id);

    const claimed = state.claimedTasks.includes(task.id);

    return `
      <div class="task">
        <label>
          <input
            type="checkbox"
            ${checked ? "checked" : ""}
            ${claimed ? "disabled" : ""}
            onchange="toggleTask('${task.id}', this.checked)"
          >
          <strong>${task.title}</strong>
        </label>

        <div>${task.reps}</div>

        <div class="reward">
          ${claimed ? "تم استلام XP" : "+" + task.xp + " XP"}
        </div>
      </div>
    `;
  }).join("");
}

function toggleTask(id, checked) {
  if (state.claimedTasks.includes(id)) return;

  if (checked && !state.completedTasks.includes(id)) {
    state.completedTasks.push(id);
  }

  if (!checked) {
    state.completedTasks =
      state.completedTasks.filter(taskId => taskId !== id);
  }

  saveState();
  renderTasks();
}

function addXP(amount) {
  state.xp += amount;

  while (state.level < 100 && state.xp >= requiredXP()) {
    state.xp -= requiredXP();
    state.level++;
    state.points += 5;

    for (const key of Object.keys(state.stats)) {
      state.stats[key] += 1;
    }

    state.rewards.push(
      "ارتقاء إلى المستوى " + state.level + " (+5 نقاط)"
    );
  }

  if (state.level === 100) {
    state.xp = Math.min(state.xp, requiredXP());
  }

  saveState();
  render();
}

function claimTasks() {
  const unclaimed = tasks.filter(task =>
    state.completedTasks.includes(task.id) &&
    !state.claimedTasks.includes(task.id)
  );

  if (unclaimed.length === 0) {
    notify("🔹 لا توجد مهام جديدة مكتملة لاستلام مكافآتها.");
    return;
  }

  let earned = 0;

  for (const task of unclaimed) {
    earned += task.xp;
    state.claimedTasks.push(task.id);
  }

  addXP(earned);

  notify("🔹 تم استلام " + earned + " XP من المهام المكتملة.");

  render();
}

function startRaid(rank) {
  const difficulty = {
    E: { level: 1, xp: 20 },
    D: { level: 5, xp: 35 },
    C: { level: 15, xp: 50 }
  };

  const raid = difficulty[rank];

  if (state.level < raid.level) {
    notify(
      "🔹 شروط الدخول غير مكتملة.\n" +
      "تحتاج إلى المستوى " + raid.level + " على الأقل."
    );
    return;
  }

  const confirmed = confirm(
    "بوابة رتبة " + rank + "\n\n" +
    "تحدٍّ افتراضي يتطلب نشاطًا مناسبًا لقدرتك.\n" +
    "هل تريد بدء الغارة؟"
  );

  if (!confirmed) return;

  const raidKey = rank + "-" + state.level;

  if (state.raids.includes(raidKey)) {
    notify("🔹 أكملت هذه الغارة بالفعل في هذا المستوى.");
    return;
  }

  state.raids.push(raidKey);
  state.rewards.push("فتح سجل غارة رتبة " + rank);

  addXP(raid.xp);

  notify(
    "🔹 اكتملت الغارة الافتراضية!\n" +
    "الرتبة: " + rank + "\n" +
    "المكافأة: +" + raid.xp + " XP"
  );

  saveState();
  render();
}

function secretMission() {
  if (state.secretClaimed) {
    notify("🔹 أنجزت المهمة السرية الحالية بالفعل.");
    return;
  }

  const confirmed = confirm(
    "🔹 المهمة السرية: الانضباط\n\n" +
    "أنجز مهمة مفيدة من حياتك اليومية، " +
    "مثل الدراسة أو ترتيب المكان أو مساعدة الأسرة.\n\n" +
    "عندما تنتهي، يمكنك تأكيد الإنجاز."
  );

  if (!confirmed) return;

  state.secretClaimed = true;
  state.rewards.push("المهمة السرية: الانضباط");

  addXP(40);

  notify(
    "🔹 تم تسجيل المهمة السرية.\n" +
    "المكافأة: +40 XP"
  );

  saveState();
  render();
}

function welcomeReward() {
  if (state.welcomeClaimed) {
    notify("🔹 استلمت مكافأة الترحيب سابقًا.");
    return;
  }

  state.welcomeClaimed = true;
  state.rewards.push("مكافأة الترحيب +10 XP");

  addXP(10);

  notify("🔹 مكافأة الترحيب: +10 XP");

  saveState();
  render();
}

render();
</script>

</body>
</html>
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskMasterApp());
}

class AppTheme {
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceAlt = Color(0xFF21262D);
  static const Color border = Color(0xFF30363D);
  static const Color primary = Color(0xFF1F6FEB);
  static const Color primaryLight = Color(0xFF58A6FF);
  static const Color success = Color(0xFF2EA043);
  static const Color danger = Color(0xFFCF222E);
  static const Color warning = Color(0xFFD29922);
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textMuted = Color(0xFF8B949E);

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: primary,
          secondary: primaryLight,
          surface: surface,
          error: danger,
          onPrimary: Colors.white,
          onSurface: textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceAlt,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryLight, width: 1.5),
          ),
        ),
      );
}

class Task {
  final String id;
  String title;
  bool done;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.done = false,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'done': done,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as String,
        title: json['title'] as String,
        done: json['done'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo Living System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const TaskHomePage(),
    );
  }
}

enum TaskFilter { all, active, completed }

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage>
    with SingleTickerProviderStateMixin {
  static const String _storageKey = 'klencod_tasks_v1';

  final List<Task> _tasks = [];
  final TextEditingController _searchController = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';
  bool _loading = true;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadTasks();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_storageKey);
      if (data != null && data.isNotEmpty) {
        final list = jsonDecode(data) as List<dynamic>;
        _tasks.clear();
        _tasks.addAll(list.map((e) => Task.fromJson(e as Map<String, dynamic>)));
      }
    } catch (_) {}
    setState(() => _loading = false);
    _fadeController.forward();
  }

  Future<void> _saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode(_tasks.map((t) => t.toJson()).toList());
      await prefs.setString(_storageKey, data);
    } catch (_) {}
  }

  void _addTask(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _tasks.insert(
        0,
        Task(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: trimmed,
          createdAt: DateTime.now(),
        ),
      );
    });
    _saveTasks();
    HapticFeedback.lightImpact();
    _showSnack('تمت إضافة المهمة', success: true);
  }

  void _toggleTask(Task task) {
    setState(() => task.done = !task.done);
    _saveTasks();
    HapticFeedback.selectionClick();
  }

  void _deleteTask(Task task) {
    final index = _tasks.indexOf(task);
    if (index == -1) return;
    setState(() => _tasks.removeAt(index));
    _saveTasks();
    _showSnack(
      'تم حذف المهمة',
      actionLabel: 'تراجع',
      onAction: () {
        setState(() => _tasks.insert(index, task));
        _saveTasks();
      },
    );
  }

  void _clearCompleted() {
    final completed = _tasks.where((t) => t.done).toList();
    if (completed.isEmpty) {
      _showSnack('لا توجد مهام مكتملة');
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => _buildConfirmDialog(
        ctx,
        title: 'حذف المهام المكتملة',
        message: 'سيتم حذف ${completed.length} مهمة مكتملة. لا يمكن التراجع.',
        onConfirm: () {
          setState(() => _tasks.removeWhere((t) => t.done));
          _saveTasks();
          Navigator.pop(ctx);
          _showSnack('تم حذف ${completed.length} مهمة', success: true);
        },
      ),
    );
  }

  void _showSnack(String message,
      {String? actionLabel, VoidCallback? onAction, bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: success ? AppTheme.success : AppTheme.textPrimary,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceAlt,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: AppTheme.primaryLight,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }

  Widget _buildConfirmDialog(
    BuildContext ctx, {
    required String title,
    required String message,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(title, style: const TextStyle(color: AppTheme.textPrimary)),
      content: Text(message, style: const TextStyle(color: AppTheme.textMuted)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('إلغاء',
              style: TextStyle(color: AppTheme.textMuted)),
        ),
        TextButton(
          onPressed: onConfirm,
          child: const Text('تأكيد',
              style: TextStyle(
                  color: AppTheme.danger, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  void _openAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: const [
            Icon(Icons.add_task_rounded, color: AppTheme.primaryLight),
            SizedBox(width: 10),
            Text('مهمة جديدة',
                style: TextStyle(color: AppTheme.textPrimary)),
          ],
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (v) {
            _addTask(v);
            Navigator.pop(ctx);
          },
          decoration: const InputDecoration(
            hintText: 'اكتب المهمة...',
            prefixIcon: Icon(Icons.edit_rounded),
          ),
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(color: AppTheme.textMuted)),
          ),
          FilledButton(
            onPressed: () {
              _addTask(controller.text);
              Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  List<Task> get _visibleTasks {
    Iterable<Task> result = _tasks;
    if (_filter == TaskFilter.active) {
      result = result.where((t) => !t.done);
    } else if (_filter == TaskFilter.completed) {
      result = result.where((t) => t.done);
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((t) => t.title.toLowerCase().contains(q));
    }
    return result.toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryLight),
        ),
      );
    }

    final visible = _visibleTasks;
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.done).length;
    final active = total - completed;
    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Solo Living System'),
        actions: [
          if (completed > 0)
            IconButton(
              tooltip: 'حذف المكتملة',
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _clearCompleted,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('مهمة جديدة',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildHeader(total, completed, active, progress),
          _buildSearchBar(),
          _buildFilters(total, active, completed),
          Expanded(
            child: visible.isEmpty
                ? _buildEmptyState()
                : _buildTaskList(visible),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int total, int completed, int active, double progress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1F6FEB), Color(0xFF0D419D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.task_alt_rounded,
                    color: Colors.white, size: 28),
                const SizedBox(width: 10),
                Text(
                  total == 0 ? 'لا توجد مهام بعد' : 'مهامك',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statChip('الإجمالي', total, Colors.white),
                _statChip('نشطة', active, AppTheme.warning),
                _statChip('مكتملة', completed, AppTheme.success),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 600),
                builder: (_, value, __) => LinearProgressIndicator(
                  value: value,
                  minHeight: 8,
                  backgroundColor: Colors.white24,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(progress * 100).toStringAsFixed(0)}% إنجاز',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'بحث في المهام...',
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppTheme.textMuted),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      color: AppTheme.textMuted),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildFilters(int total, int active, int completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _filterChip('الكل', TaskFilter.all, total),
          const SizedBox(width: 8),
          _filterChip('نشطة', TaskFilter.active, active),
          const SizedBox(width: 8),
          _filterChip('مكتملة', TaskFilter.completed, completed),
        ],
      ),
    );
  }

  Widget _filterChip(String label, TaskFilter filter, int count) {
    final selected = _filter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filter = filter),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppTheme.primary : AppTheme.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppTheme.primaryLight : AppTheme.border,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  color: selected ? Colors.white : AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white70 : AppTheme.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> visible) {
    return FadeTransition(
      opacity: _fadeController,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final task = visible[index];
          return _buildTaskItem(task);
        },
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.danger,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_rounded,
            color: Colors.white, size: 26),
      ),
      confirmDismiss: (_) async {
        _deleteTask(task);
        return false;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: task.done
                ? AppTheme.success.withOpacity(0.4)
                : AppTheme.border,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _toggleTask(task),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: task.done
                          ? AppTheme.success
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: task.done
                            ? AppTheme.success
                            : AppTheme.textMuted,
                        width: 2,
                      ),
                    ),
                    child: task.done
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            color: task.done
                                ? AppTheme.textMuted
                                : AppTheme.textPrimary,
                            fontSize: 15,
                            decoration: task.done
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: AppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(task.createdAt),
                          style: const TextStyle(
                            color: AppTheme.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'حذف',
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: AppTheme.textMuted),
                    onPressed: () => _deleteTask(task),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
    if (diff.inDays < 1) return 'منذ ${diff.inHours} ساعة';
    if (diff.inDays == 1) return 'أمس';
    return 'منذ ${diff.inDays} يوم';
  }

  Widget _buildEmptyState() {
    final String message;
    final IconData icon;
    if (_searchQuery.isNotEmpty) {
      message = 'لا توجد نتائج للبحث';
      icon = Icons.search_off_rounded;
    } else if (_filter == TaskFilter.completed) {
      message = 'لا توجد مهام مكتملة بعد';
      icon = Icons.check_circle_outline_rounded;
    } else if (_filter == TaskFilter.active) {
      message = 'كل المهام مكتملة!';
      icon = Icons.celebration_rounded;
    } else {
      message = 'ابدأ بإضافة مهمتك الأولى';
      icon = Icons.playlist_add_rounded;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.border),
            ),
            child: Icon(icon, size: 56, color: AppTheme.primaryLight),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'استخدم الزر أدناه للبدء',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}