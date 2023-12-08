import 'package:grouping_project/threads/domains/repo/gpt_text_completions_repo.dart';

class GetGptResponseUseCase {
  final GptTextCompletionsRepo _gptRepository;

  GetGptResponseUseCase(this._gptRepository);

  Future<String> call(String message) async {
    return await _gptRepository.getGptTextCompletions(message: message);
  }
}
