# meme_card_game

A small card game project where I tried the flutter_bloc package and Supabase Realtime (like Websockets but isomorphic). The game consists in the fact that the user must choose a situation (or it occurs on the server), after which the players in the conate vote for the most suitable pictures for the situation. For each vote, the user receives a point. The game is similar to the game from the real world, but transferred to the digital format. The project is not perfect, but some properties of the author in the collection of previously unknown technologies and, possibly, in the future will be significantly improved.

## Getting Started

## Used stack
- [Supabase](https://supabase.com/): Supabase is an open source Firebase alternative. It's better thanks to PostgreSQL, RPC and other useful things on the backend side. Used it like a backend;
- flutter_bloc: state management. In this project i used only Cubit.
- go_router: a declarative routing package for Flutter that uses the Router API to provide a convenient, url-based API for navigating between different screens.
- carousel_slider: A carousel slider widget. I used for cards.
- Other: nanoid, flutter_dotenv.

## Features
### Global

### Authentication
- [x] Sign up;
- [x] Sign in.

### Home
- [x] Choose create game or join;
- [x] Log out.

### Game
- [x] Realtime game (Supabase websockets);
- [x] Create room with game configurations;
- [x] Join room;
- [x] Lobby with confirmation and exists check;
- [x] Add situations;
- [x] Card pick;
- [x] Voting for cards;
- [x] Players points;
- [x] Game ranks in finish screen.

## Ways of improving
- [ ] Use environments in flutter with yaml (remove flutter_dotenv);
- [ ] Clean architecture;
- [ ] Dependency injection with flutter_bloc;
- [ ] Redesign: Player profile, Game Space;
- [ ] Game logic: timers, skip round.

## App demonstration
### Video demonstration

todo

### App download

todo

## How to launch app
### Supabase and [auto_scripts](./auto_scripts/README.md)
1. Sign up to Supabase;
2. Set up Supabase with [Supabase README.md](./supabase/README.md);
3. Set up data in Supabase project. Get and paste data to environments from Supabase project: SUPABASE_ANNON_KEY, SUPABASE_URL. You can find environments in yaml files (.env.development.yaml) in root [auto_scripts](./auto_scripts/README.md) directory.

### [App](./app/README.md)
1. Get and paste data to environments from Supabase project: SUPABASE_ANNON_KEY, SUPABASE_URL. You can find environments in dot files (.env.development) in root flutter project.

## Author contacts
Made by @yokawaiik

<p>
  <a href="https://mail.google.com/mail/u/0/#search/yokawaiik%40gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"/></a>
  <a href="https://instagram.com/yokawaiik"><img src="https://img.shields.io/badge/instagram-E4405F.svg?style=for-the-badge&logo=instagram&logoColor=white"/></a>
  <a href="https://linkedin.com/in/danil-shubin"><img src="https://img.shields.io/badge/linkedin-0077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white"/></a>
  <a href="https://t.me/yokawaiik"><img src="https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white"/></a>
</p>


## License
GPL