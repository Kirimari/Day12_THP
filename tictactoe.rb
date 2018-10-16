class BoardCase # création d'une class qui définit une cellule

  attr_accessor :value, :box_number # permet de lire et modifier la valeur (X ou O) et le numéro de la case dans le tableau

  def initialize(box_number) # définition des variables
    @value = " "
    @box_number = box_number
  end

  def to_s # permet de transformer la valeur en string (X ou O)
    @value = value.to_s
  end

end

class Board # création d'une class qui définit le tableau et les méthodes associées

  attr_accessor :cases # permet de lire et modifier le tableau cases

  def initialize # définition du tableau grâce à la class BoardCase pour avoir 9 instances vides
    @cases = [
      @case1 = BoardCase.new(1), @case2 = BoardCase.new(2), @case3 = BoardCase.new(3),
      @case4 = BoardCase.new(4), @case5 = BoardCase.new(5), @case6 = BoardCase.new(6),
      @case7 = BoardCase.new(7), @case8 = BoardCase.new(8), @case9 = BoardCase.new(9)
    ]
  end

  def display # affichage du tableau
    puts "▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    puts "█         █         █         █"
    puts "█         █         █         █"
    puts "█    #{@case1}    █   #{@case2}     █    #{@case3}    █"
    puts "█         █         █         █"
    puts "█▄▄▄▄▄▄▄▄▄█▄▄▄▄▄▄▄▄▄█▄▄▄▄▄▄▄▄▄█"
    puts "█         █         █         █"
    puts "█         █         █         █"
    puts "█    #{@case4}    █   #{@case5}     █    #{@case6}    █"
    puts "█         █         █         █"
    puts "█▄▄▄▄▄▄▄▄▄█▄▄▄▄▄▄▄▄▄█▄▄▄▄▄▄▄▄▄█"
    puts "█         █         █         █"
    puts "█         █         █         █"
    puts "█    #{@case7}    █   #{@case8}     █    #{@case9}    █"
    puts "█         █         █         █"
    puts "█▄▄▄▄▄▄▄▄▄█▄▄▄▄▄▄▄▄▄█▄▄▄▄▄▄▄▄▄█"
    puts ""
    puts ""
  end

  def full? # on définit si le tableau est plein ou pas
    counter = 0 # mise en place d'un compteur
    @cases.each do |c|
      counter += 1 if c.value == 'X' || c.value == 'O' # on vérifie si chaque case contient X ou O
    end
    if counter == 9 # dès que le compteur atteint 9 on renvoie true
      return true
    else
      return false
    end
  end

  def turn_count # chaque tour est comptabilisé dès qu'un symbole remplit la case
    @cases.count{ |char| char.value == "O" || char.value == "X"}
  end

  def position(input) #ici, nous allons récupérer la position souhaitée par le joueur et retourner la valeur de la cellule du tableau
    @cases[input].value # ici on récupère la valeur (X ou O) et la position dans le tableau
  end

  def update(user_input, current_token) # met à jour la cellule du tableau avec la valeur (X ou O) en fonction de la position choisie par le joueur
    @cases[user_input].value = current_token # représente X ou O
  end

  def taken?(input) # on vérifie qu'une cellule n'est pas déjà prise, retourne true ou false
    position(input)=="X" || position(input)=="O" #on récupère la méthode position et on vérifie s'il y a déjà un X ou un O sur cette même position
  end

end

class Player # création d'une class qui va créer les joueurs

  attr_accessor :name, :token # permet de lire et modifier le nom des joueurs et le symbole associé

  def initialize(name, token) # on initialise les variables nom et symbole
    @name = name
    @token = token
  end
end

class Game # création d'un class qui va poser les règles du jeu

  # définition des combinaisons gagnantes
  WIN_COMBINATIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]

  def initialize # on initialise une partie avec définition des joueurs et assignation des token à chaque joueur
    puts "C'est parti pour un Tic Tac Toe de foly!!"
    puts "Joueur 1, quel est ton prénom ?"
    @player1 = Player.new(gets.chomp, "X")
    puts "Bienvenue #{@player1.name}, tu joueras avec les #{@player1.token}"
    puts "Joueur 2, quel est ton prénom ?"
    @player2 = Player.new(gets.chomp, "O")
    puts "Bienvenue #{@player2.name}, tu joueras avec les #{@player2.token}"
    @board = Board.new
  end

  def current_player # définition du joueur actuel
    if @board.turn_count % 2 == 0 # nous appelons la méthode turn_count de la class Board et on dit que le joueur 1 aura tous les tours impairs et le joueur 2 aura tous les tours pairs
      return @player1
    else
      return @player2
    end
  end

  def go # définition de la méthode qui lance le jeu
    @board.display # affiche le plateau de jeu
    begin
      player = current_player # on définit une variable qui prend le joueur actuel
      begin
        puts "#{player.name}, choisis un nombre entre 1 et 9 :"
        user_input = gets.chomp.to_i-1
        @board.taken?(user_input) # on vérifie que le choix du joueur n'est pas déjà pris
      end while @board.taken?(user_input) # Todo!!!!!

      @board.update(user_input, player.token) # on met à jour le tableau avec la méthode update définie auparavant
      @board.display # on affiche le tableau mis à jour
    end while over? # tant que personne n'a gagné et que le tableau n'est pas rempli, on relance la boucle (au premier begin)
    p "Partie finie"
    # todo : Gérer la fin de partie


  end

  def won? # définition des combinaisons gagnantes en fonction du tableau mis à jour
    case
    when @board.cases[0].value == @board.cases[1].value && @board.cases[0].value == @board.cases[2].value && @board.cases[0].value != " " # la ligne du haut a les mêmes symbolse et on exclu les espaces des conditions de victoires
      return true
    when @board.cases[3].value == @board.cases[4].value && @board.cases[3].value == @board.cases[5].value && @board.cases[4].value != " " # ligne du milieu
      return true
    when @board.cases[6].value == @board.cases[7].value && @board.cases[6].value == @board.cases[8].value && @board.cases[6].value != " " # ligne du bas
      return true
    when @board.cases[0].value == @board.cases[3].value && @board.cases[0].value == @board.cases[6].value && @board.cases[0].value != " " # colonne de gauche
      return true
    when @board.cases[1].value == @board.cases[4].value && @board.cases[1].value == @board.cases[7].value && @board.cases[4].value != " " # colonne du centre
      return true
    when @board.cases[2].value == @board.cases[5].value && @board.cases[2].value == @board.cases[8].value && @board.cases[2].value != " " # colonne de droite
      return true
    when @board.cases[0].value == @board.cases[4].value && @board.cases[0].value == @board.cases[8].value && @board.cases[0].value != " " # diagonale 1/5/9
      return true
    when @board.cases[2].value == @board.cases[4].value && @board.cases[2].value == @board.cases[6].value && @board.cases[2].value != " " # diagonale 7/5/3
      return true
    else
      return false
    end
  end

  def draw? # on définit s'il y a une égalité, retourne true ou false
    @board.full? && !won? #on regarde si le tableau est rempli et que la méthode won? renvoie false (grâce au !)
  end

  def over? # on définit quand la partie est terminée (on regarde si le tableau est rempli ou si un joueur a gagné), retourne true ou false
    !(@board.full? || won?)
  end

  #def turn

  #end

  def winner
    if winning_combo = won?
      @winner = @board.case[winning_combo.first].value
    end
  end

end

jeu = Game.new
jeu.go
