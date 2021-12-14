from sqlalchemy import Table, Column, Integer, BIGINT, String, MetaData, ForeignKey, create_engine
from sqlalchemy.orm import mapper, relation, sessionmaker
from sqlalchemy_utils import database_exists, create_database


def load_db():

    global engine
    engine = create_engine('postgresql://postgres:1597@localhost/proj', echo=True)

    if not database_exists(engine.url):
        create_database(engine.url)

    global metadata
    metadata = MetaData(engine)

    class CharactersClass:
        def __init__(self, id, character_name, racess, cl, level, world_n, mount_name):
            self.id = id
            self.character_name = character_name
            self.race = racess
            self.clas = cl
            self.level = level
            self.world_name = world_n
            self.mount_name = mount_name

        def __repr__(self):
            return self.id

    class WorldsClass:
        def __init__(self, world_name, script, amount_of_players):
            self.world_name = world_name
            self.script = script
            self.amount_of_players = amount_of_players

        def __repr__(self):
            return self.world_name

    class ClassesClass:
        def __init__(self, clas, specification, main_ability, passive_ability, ultimate_ability,
                     cooldown_of_main_ability, cooldown_of_ultimate_ability):
            self.clas = clas
            self.specification = specification
            self.main_ability = main_ability
            self.passive_ability = passive_ability
            self.ultimate_ability = ultimate_ability
            self.cooldown_of_main_ability = cooldown_of_main_ability
            self.cooldown_of_ultimate_ability = cooldown_of_ultimate_ability

        def __repr__(self):
            return self.clas

    class RacesClass:
        def __init__(self, race, health_limit, speed_limit, amount_of_players):
            self.race = race
            self.health_limit = health_limit
            self.speed_limit = speed_limit
            self.amount_of_players = amount_of_players

        def __repr__(self):
            return self.race

    characters_table = Table('characters', metadata,
                             Column('id', BIGINT, primary_key=True, nullable=False),
                             Column('character_name', String(50), nullable=False),
                             Column('race', ForeignKey('races.race'), nullable=False),
                             Column('clas', ForeignKey('classes.clas'), nullable=False),
                             Column('level', Integer, nullable=False),
                             Column('world_name', ForeignKey('worlds.world_name'), nullable=False),
                             Column('mount_name', String(50), nullable=False))

    worlds_table = Table('worlds', metadata,
                         Column('world_name', String(50), primary_key=True, nullable=False),
                         Column('script', String(100), nullable=False),
                         Column('amount_of_players', Integer, nullable=False))

    classes_table = Table('classes', metadata,
                          Column('clas', String(20), primary_key=True, nullable=False),
                          Column('specification', String(50), nullable=False),
                          Column('main_ability', String(50), nullable=False),
                          Column('passive_ability', String(50), nullable=False),
                          Column('ultimate_ability', String(50), nullable=False),
                          Column('cooldown_of_main_ability', Integer, nullable=False),
                          Column('cooldown_of_ultimate_ability', Integer, nullable=False), )

    races_table = Table('races', metadata,
                        Column('race', String(20), primary_key=True, nullable=False),
                        Column('health_limit', String(75), nullable=False),
                        Column('speed_limit', String(75), nullable=False),
                        Column('amount_of_players', Integer, nullable=False))

    metadata.create_all(engine)

    mapper(CharactersClass, characters_table)
    mapper(WorldsClass, worlds_table, properties={'worlds': relation(CharactersClass, backref='world_n')})
    mapper(ClassesClass, classes_table, properties={'classes': relation(CharactersClass, backref='cl')})
    mapper(RacesClass, races_table, properties={'races': relation(CharactersClass, backref='racess')})

    Session = sessionmaker(bind=engine)
    session = Session()

    # data
    worlds = [['Balanced_1', 'No privileges. All races are in the same conditions', 0],
              ['Balanced_2', 'No privileges. All races are in the same conditions', 0],
              ['Call_of_Horde',
               'Orks and Goblins have a special spawn.Speed and damage bonus on native earth.Others need to survive',
               0],
              ['New_Kingdom',
               'New king ascended the throne. Humans can support him or try to overthrow.Alliances is available', 0],
              ['Mountains',
               'Entire world is an earth of dwarfs. Claim all the treasure of dwarfs or help them with protection', 0],
              ['Beautiful_forest', 'Elfs have a special spawn. Damage, speed and health bonus on native earth', 0],
              ['Undeads_uprising',
               'Undead have a special spawn.Damage bonus on native earth.Cooldown of main ability of undead is1 less',
               0]]

    races = [['human', '1.25level^230', '1.3level + 10', 0],
             ['ork', '1.35level^250', '1.1level + 8', 0],
             ['elf', '1.2level^220', '1.35level + 12', 0],
             ['night_elf', '1.25level^220', '1.3level + 11', 0],
             ['dwarf', '1.3level^240', '1.2level + 6', 0],
             ['undead', '1.20level^230', '1.2level + 9', 0],
             ['goblin', '1.15level^215', '1.5*level + 15', 0]]

    clas = [['warrior', 'fighter', 'hits with a shield and stunning nearest enemy', 'increases melee damage 1.2level',
             'create an arena(1.5all atributes)', 5, 60],
            ['archer', 'killer', 'shoots a frozen arrow.Stun for 3sec', 'increases ranged dmg 1.1level',
             'arrows receive elemental damage', 8, 70],
            ['mage', 'caster', 'casts a spell from the magic book', 'increase damage from chosen element',
             'creates an elemental field with certain effect', 5, 10],
            ['priest', 'support/caster', 'applies a shield and heals 20%', '5% chance to avoid damage',
             'create an arena(heal 2%/sec)', 9, 60],
            ['necromancer', 'caster/specialist', 'uses a soul to spawn an undead',
             'every enemies drop soul after death', 'revives allies for 10 seconds', 5, 80],
            ['paladin', 'fighter/support', 'all hits heal allies for 1% (1m range)',
             'every hit can randomly stun every 10 sec', 'give all nearest allies bonus defence', 5, 60],
            ['thief', 'killer/support', 'all enemies in range 5m gain effect of bleeding',
             'every hit can randomly steal some gold every 15s', 'imposes a disguise effect on closest allies', 4, 45],
            ['monk', 'support', 'give random buff', 'gives 2% of bonus health in 2m range',
             'Disarms opponents for 5 seconds', 3, 65],
            ['berserk', 'fighter/killer', 'throws his axes 2 m ahead',
             'every 2% of lost hp gain 3% of damage and defence', 'imposes a vampirism effect on closest allies', 5,
             60],
            ['knight', 'fighter/protector', 'increase defence of closest allies for 5%',
             'all damage coming from the front is reduced by 5%', 'gives his passive ability on closest allies for10s',
             8, 65],
            ['summoner', 'caster/specialist', 'summone special creature',
             'increases damage of all summoned units for 3%', 'improves creatures atributes(1.7all atributes)', 5, 60]]

    for i in worlds:
        exists = session.query(WorldsClass).filter_by(world_name=i[0]).first()
        if not exists:
            temp = WorldsClass(i[0], i[1], i[2])
            session.add(temp)

    for i in clas:
        exists = session.query(ClassesClass).filter_by(clas=i[0]).first()
        if not exists:
            temp = ClassesClass(i[0], i[1], i[2], i[3], i[4], i[5], i[6])
            session.add(temp)

    for i in races:
        exists = session.query(RacesClass).filter_by(race=i[0]).first()
        if not exists:
            temp = RacesClass(i[0], i[1], i[2], i[3])
            session.add(temp)

    session.commit()