
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:highty_inventory/data/repositories/history_repository_impl.dart';
import 'package:highty_inventory/domain/usecases/history.dart';
import 'package:highty_inventory/presentation/bloc/history_cubit.dart';
import 'package:highty_inventory/presentation/constants/fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context){
    final supabaseClient = Supabase.instance.client;
    final historyRepository = HistoryRepositoryImpl(supabaseClient);

    return BlocProvider(
      create: (context) => HistoryCubit(FetchHistoryUseCase(historyRepository))..fetchHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('History', style: primary),
        ),
        body: HistoryTable(),
      )
    );
  }
}  


class HistoryTable extends StatefulWidget {
  const HistoryTable({super.key});

  @override
  State<HistoryTable> createState() => _HistoryTableState();
}

class _HistoryTableState extends State<HistoryTable> {
  @override
  void initState() {
    super.initState();
    // Fetch the history when the screen initializes
    context.read<HistoryCubit>().fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        } else if (state.history == null || state.history!.isEmpty) {
          return Center(child: Text('No history found.'));
        } else {
          return ListView.builder(
            itemCount: state.history!.length,
            itemBuilder: (context, index) {
              final historyItem = state.history![index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
                child: Card(
                  child: ListTile(
                    title: Text(historyItem.nama),
                    subtitle: Text(historyItem.item),
                    trailing: Text(historyItem.time),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

// class HistoryItem {
//   final String title;
//   final String description;
//   final String time;

//   HistoryItem(this.title, this.description, this.time);
// }