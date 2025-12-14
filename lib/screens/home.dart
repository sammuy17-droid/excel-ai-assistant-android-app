import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../backend.dart';
import '../l10n.dart';
import '../settings.dart';

class HomeScreen extends StatefulWidget {
  final SettingsController settings;
  const HomeScreen({super.key, required this.settings});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _file;
  Map<String, dynamic>? _result;
  bool _connecting = false;
  bool _processing = false;
  String? _error;

  Future<void> _pickFile() async {
    setState(() {
      _error = null;
      _result = null;
    });
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'xlsm', 'csv', 'tsv'],
      withData: false,
    );
    if (res == null || res.files.isEmpty) return;
    final path = res.files.single.path;
    if (path == null) return;
    setState(() => _file = File(path));
  }

  Future<void> _analyze() async {
    final s = AppStrings.of(context);
    if (_file == null) return;

    setState(() {
      _connecting = true;
      _processing = false;
      _error = null;
      _result = null;
    });

    final ok = await BackendApi.waitUntilReady();
    if (!ok) {
      setState(() {
        _connecting = false;
        _error = s.t('backendDown');
      });
      return;
    }

    setState(() {
      _connecting = false;
      _processing = true;
    });

    try {
      final data = await BackendApi.processFile(
        file: _file!,
        lang: widget.settings.locale.languageCode,
      );
      setState(() {
        _processing = false;
        _result = data;
      });
    } catch (e) {
      setState(() {
        _processing = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.t('appTitle')),
        actions: [
          IconButton(
            tooltip: s.t('settings'),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  s.t('madeBy'),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroCard(
              title: s.t('homeTitle'),
              subtitle: s.t('fileTypesHint'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.upload_file_rounded),
                    label: Text(s.t('pickFile')),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _file == null ? '' : '${s.t('selectedFile')}: ${_file!.path.split(Platform.pathSeparator).last}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: (_file == null || _connecting || _processing) ? null : _analyze,
                    child: _connecting
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                              const SizedBox(width: 10),
                              Text(s.t('backendWaking')),
                            ],
                          )
                        : _processing
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(s.t('analyze')),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: _ResultCard(title: s.t('result'), result: _result, emptyText: s.t('noResult')),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const _HeroCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer.withOpacity(0.65),
            theme.colorScheme.secondaryContainer.withOpacity(0.45),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final Map<String, dynamic>? result;
  final String emptyText;
  const _ResultCard({required this.title, required this.result, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: result == null
            ? Center(
                child: Text(emptyText, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    _kv('Filename', result!['filename']?.toString()),
                    _kv('SHA256', result!['sha256']?.toString()),
                    const Divider(height: 24),
                    _AnalysisView(analysis: result!['analysis'] as Map<String, dynamic>),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _kv(String k, String? v) {
    if (v == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}

class _AnalysisView extends StatelessWidget {
  final Map<String, dynamic> analysis;
  const _AnalysisView({required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = analysis['rows'];
    final cols = analysis['cols'];
    final missing = (analysis['missing'] as Map).cast<String, dynamic>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Shape: $rows x $cols', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text('Missing values (top):', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        ...missing.entries.take(8).map((e) => Text('• ${e.key}: ${e.value}')),
        const SizedBox(height: 12),
        Text('Preview (first 20 rows):', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        _PreviewTable(rows: (analysis['preview'] as List).cast<Map<String, dynamic>>()),
      ],
    );
  }
}

class _PreviewTable extends StatelessWidget {
  final List<Map<String, dynamic>> rows;
  const _PreviewTable({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const Text('—');
    final cols = rows.first.keys.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: cols.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.w700)))).toList(),
        rows: rows.take(8).map((r) {
          return DataRow(cells: cols.map((c) => DataCell(Text((r[c] ?? '').toString()))).toList());
        }).toList(),
      ),
    );
  }
}
