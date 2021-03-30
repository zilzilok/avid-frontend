class Validator {
  static login() {
    return (String login) {
      RegExp regex =
          RegExp(r'^[a-zA-Z0-9]([._-](?![._-])|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]$');
      if (!regex.hasMatch(login)) {
        return "введен недопустимый логин";
      }
      return null;
    };
  }

  static passwordNotEmpty() {
    return (String password) {
      if (password.isEmpty) {
        return "пароль не может быть пустым";
      }
      return null;
    };
  }

  static notEmpty() {
    return (String password) {
      if (password.trim().isEmpty) {
        return "это поле не может быть пустым";
      }
      return null;
    };
  }

  static email() {
    return (String email) {
      String regexStr = "^(?=.{1,64}@)(?:(\"[^\"\\\\]*(?:\\\\.[^\"\\\\]*)*\"@)|((?:[0-9a-z](?:\\.(?!\\.)|[-!#\\\$%&'\\*\\+/=\\?\\^`\\{\\}\\|~\\w])*)?[0-9a-z]@))(?=.{1,255}\$)(?:(\\[(?:\\d{1,3}\\.){3}\\d{1,3}\\])|((?:(?=.{1,63}\\.)[0-9a-z][-\\w]*[0-9a-z]*\\.)+[a-z0-9][\\-a-z0-9]{0,22}[a-z0-9])|((?=.{1,63}\$)[0-9a-z][-\\w]*))\$";
      RegExp regex = RegExp(
        regexStr,
        caseSensitive: false,
        multiLine: true,
      );
      if (!regex.hasMatch(email)) {
        return "введен недопустимый email";
      }
      return null;
    };
  }
}
