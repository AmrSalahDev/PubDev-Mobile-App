---
trigger: always_on
---

# Project Rules & Guidelines

## 🏗 Architecture (Clean Architecture)

This project follows a feature-driven Clean Architecture approach. Each feature is organized into three main layers:

### 1. **Domain Layer** (The Core)

- **Entities**: Simple data classes (use `Equatable`).
- **Repositories (Interfaces)**: Abstract classes defining the contract for data operations.
- **Use Cases**: Specific business logic units that call repository methods.

### 2. **Data Layer** (The Implementation)

- **Data Sources**: Handle raw data from APIs (Remote) or Local databases.
- **Repositories (Implementations)**: Implement the domain repository interfaces, coordinating data from various sources.
- **Models**: DTOs (Data Transfer Objects) for JSON parsing.

### 3. **Presentation Layer** (The UI)

- **Bloc/Cubit**: Manage state and handle business logic for the UI.
- **Pages**: Main screens of the application.
- **Widgets**: Reusable UI components.

---

## 🛠 State Management

- Use **Flutter BLoC** for all state-related logic.
- Always use `Equatable` for States and Events to ensure efficient rebuilding.
- Prefer `emit(state.copyWith(...))` rather than creating new state instances from scratch.

---

## 💉 Dependency Injection

- Use **Injectable** and **GetIt**.
- Annotate Use Cases with `@lazySingleton`.
- Annotate BLocs with `@injectable`.
- Always generate the injection container after adding new dependencies.

---

## 🎨 UI & Styling

- **Responsive Design**: Use `flutter_screenutil` (`.w`, `.h`, `.sp`, `.sw`, `.sh`) for all dimensions.
- **Assets**: Use `flutter_gen` for type-safe asset references.
- **Colors**: Keep colors in the theme or a dedicated color constants file.

---

## ✨ Clean Code Principles

1. **Naming**: Classes should be descriptive (e.g., `GetPackageInfoUsecase`).
2. **SOLID**: Follow SOLID principles strictly.
3. **Small Methods**: Keep methods focused and short.
4. **No Logic in UI**: Pages should be thin; move logic to Blocs/Usecases.
5. **Error Handling**: Always handle errors in the Bloc/Usecase level and update the state with descriptive error messages.
6. **DRY**: Don't repeat yourself. Extract common logic into helper classes or extensions.

---

## Hardcoded Strings

- **NEVER** use hardcoded strings in the UI. Always use the `AppLocalizations` class.

## TextTheme And ColorScheme

- **NEVER** use TextSyle and hardcoded color always use TextTheme and ColorScheme
